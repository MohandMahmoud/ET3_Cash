import warnings
import psycopg2
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import dask.dataframe as dd
from dask.diagnostics import ProgressBar
from sklearn.decomposition import PCA
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LinearRegression, Ridge, Lasso, ElasticNet
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.svm import SVR
from sklearn.tree import DecisionTreeRegressor
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.cluster import KMeans, AgglomerativeClustering, DBSCAN, MeanShift, Birch, SpectralClustering
from sklearn.mixture import GaussianMixture
from xgboost import XGBRegressor
from lightgbm import LGBMRegressor
from catboost import CatBoostRegressor
from keras import models
from tensorflow.keras.layers import Dense, Dropout
from tensorflow.keras.optimizers import Adam
from sklearn.preprocessing import StandardScaler
import random

warnings.filterwarnings("ignore")

# Database connection string
connection_string = "postgresql://postgres.rmywqhaxmkpxmfkzyczn:e9Ty!d_W3m-Fu-U@aws-0-eu-central-1.pooler.supabase.com:6543/postgres"


def connect_to_database():
    try:
        conn = psycopg2.connect(connection_string)
        print("Database connection successful")
        return conn
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None


# 1. Data Collection and Preprocessing
def load_data_from_db(query):
    conn = connect_to_database()
    if conn:
        df = pd.read_sql_query(query, conn)
        conn.close()
        print("Columns in the DataFrame:", df.columns)  # Print columns to verify
        return df
    return pd.DataFrame()


def replace_infinite_values(df):
    """
    Replace infinite values in the DataFrame with NaN.
    """
    return df.replace([np.inf, -np.inf], np.nan)


def handle_missing_values(df, strategy='mean'):
    """
    Impute missing values in the DataFrame based on the specified strategy.
    """
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    non_numeric_cols = df.select_dtypes(exclude=[np.number]).columns

    # Fill numeric columns using the chosen strategy
    imputer = SimpleImputer(strategy=strategy)
    df[numeric_cols] = pd.DataFrame(imputer.fit_transform(df[numeric_cols]), columns=numeric_cols)

    # Fill non-numeric columns with a default value
    for col in non_numeric_cols:
        if df[col].dtype == 'object':
            mode_value = df[col].mode()[0] if not df[col].mode().empty else 'unknown'
            df[col] = df[col].fillna(mode_value)

    # Specific handling for datetime columns
    for col in df.columns:
        if np.issubdtype(df[col].dtype, np.datetime64):
            df[col] = df[col].fillna(pd.Timestamp('1970-01-01'))  # Default epoch date

    # Check for any remaining NaN values
    print("Columns with NaN values after imputation:")
    print(df.isnull().sum())

    if df.isnull().values.any():
        raise ValueError("There are still NaN values in the DataFrame after imputation.")

    return df


def filter_negative_values(df):
    """
    Filter out rows with negative values in numeric columns.
    """
    return df[df.select_dtypes(include=[np.number]).ge(0).all(1)]


def convert_datetime_columns(df):
    """
    Convert datetime columns to integer timestamps.
    """
    datetime_cols = df.select_dtypes(include=[np.datetime64]).columns
    for col in datetime_cols:
        df[col] = df[col].astype('int64')
    return df


def encode_categorical_columns(df):
    """
    Encode categorical columns using numerical codes.
    """
    non_numeric_cols = df.select_dtypes(exclude=[np.number]).columns
    for col in non_numeric_cols:
        if df[col].dtype == 'object':
            df[col] = pd.Categorical(df[col]).codes
    return df


def clean_data(df):
    """
    Clean the DataFrame by handling NaN values, filtering negative values,
    and converting data types.
    """
    try:
        df = replace_infinite_values(df)
        df = handle_missing_values(df, strategy='mean')
        df = filter_negative_values(df)
        df = convert_datetime_columns(df)
        df = encode_categorical_columns(df)
        return df
    except ValueError as e:
        print(f"Error during data cleaning: {e}")
        raise


def plot_feature_distributions(df, columns):
    """
    Plot histograms for the specified columns to understand data distribution.
    """
    for col in columns:
        if col in df.columns:
            plt.figure(figsize=(10, 4))
            sns.histplot(df[col], kde=True)
            plt.title(f'Distribution of {col}')
            plt.show()
        else:
            print(f"Column '{col}' not found in DataFrame.")


def feature_engineering(df):
    """
    Apply log transformation to all numeric columns to reduce skewness.
    """
    for column in df.columns:
        if pd.api.types.is_numeric_dtype(df[column]):
            df[f'log_{column}'] = np.log1p(df[column])
    return df


def DataAnalysis(df):
    """
    Perform exploratory data analysis by printing summary statistics and plotting a pairplot.
    """
    print("Summary Statistics:")
    print(df.describe().to_string())

    columns_to_plot = ['amount', 'transaction_type_id', 'user_id']
    subset_df = df[columns_to_plot]
    sns.pairplot(subset_df, diag_kind='kde')
    plt.show()

    # Additional correlation heatmap
    plt.figure(figsize=(200, 200))
    sns.heatmap(df.corr(), annot=True, cmap='coolwarm', vmin=-1, vmax=1)
    plt.title('Correlation Matrix')
    plt.show()


def MachineLearning_Supervised_learning_models(df, target_col='amount'):
    """
    Train, evaluate, and visualize multiple supervised learning models, including polynomial and multiple regression.
    """
    try:
        from sklearn.preprocessing import PolynomialFeatures
        from sklearn.pipeline import Pipeline

        df = convert_datetime_columns(df)
        df = encode_categorical_columns(df)
        df = df.apply(pd.to_numeric, errors='coerce').fillna(df.mean())

        X = df.drop(target_col, axis=1)
        y = df[target_col]

        # Split the data into training and testing sets
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # One-hot encode categorical columns
        categorical_cols = [col for col in X.columns if X[col].dtype == 'int64' or X[col].dtype == 'object']
        X_train = pd.get_dummies(X_train, columns=categorical_cols, drop_first=True)
        X_test = pd.get_dummies(X_test, columns=categorical_cols, drop_first=True)

        # Align columns
        X_train, X_test = X_train.align(X_test, join='left', axis=1, fill_value=0)

        # List of supervised learning algorithms
        algorithms = {
            "Linear Regression": LinearRegression(),
            "Polynomial Regression (Degree 2)": Pipeline([
                ("poly_features", PolynomialFeatures(degree=2)),
                ("linear_reg", LinearRegression())
            ]),
            "Random Forest Regressor": RandomForestRegressor(random_state=42),
            "Gradient Boosting Regressor": GradientBoostingRegressor(random_state=42),
            "Support Vector Regressor": SVR(),
            "Decision Tree Regressor": DecisionTreeRegressor(random_state=42),
            "Ridge Regression": Ridge(),
            "Lasso Regression": Lasso(),
            "ElasticNet Regression": ElasticNet(),
            "XGBoost Regressor": XGBRegressor(random_state=42),
            "LightGBM Regressor": LGBMRegressor(random_state=42),
            "CatBoost Regressor": CatBoostRegressor(verbose=0),
            "Multiple Regression (Linear)": LinearRegression()
        }

        best_model = None
        best_score = float('-inf')

        # Train and evaluate each model
        for name, model in algorithms.items():
            model.fit(X_train, y_train)
            predictions = model.predict(X_test)

            # Calculate metrics
            mse = mean_squared_error(y_test, predictions)
            r2 = r2_score(y_test, predictions)
            print(f"Model: {name}")
            print(f"Mean Squared Error: {mse:.2f}")
            print(f"R^2 Score: {r2:.2f}\n")

            if r2 > best_score:
                best_model = model
                best_score = r2

            # Visualization: Plot predicted vs. actual values
            plt.figure(figsize=(8, 6))
            plt.scatter(y_test, predictions, alpha=0.7, edgecolor='k')
            plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--')  # Reference line
            plt.title(f"{name} (R^2: {r2:.2f})")
            plt.xlabel("Actual Values")
            plt.ylabel("Predicted Values")
            plt.grid(True)
            plt.show()

        print(f"Best Model: {best_model.__class__.__name__} with R^2 Score: {best_score:.2f}")

    except Exception as e:
        print(f"Error during supervised learning: {e}")
        raise


def MachineLearning_UN_Supervised_learning_models(df, n_clusters=3):
    """
    Apply multiple clustering algorithms to the DataFrame and visualize results using Matplotlib.
    """
    global labels
    try:
        df = convert_datetime_columns(df)
        df = df.apply(pd.to_numeric, errors='coerce').fillna(df.mean())

        X = df.select_dtypes(include=[np.number])
        if X.isnull().values.any():
            X = X.fillna(X.mean())

        # Reduce dimensions for visualization (if necessary)
        if X.shape[1] > 2:
            pca = PCA(n_components=2)
            X_reduced = pca.fit_transform(X)
        else:
            X_reduced = X.values

        # List of unsupervised learning algorithms
        algorithms = {
            "KMeans": KMeans(n_clusters=n_clusters, random_state=42),
            "Agglomerative Clustering": AgglomerativeClustering(n_clusters=n_clusters),
            "DBSCAN": DBSCAN(eps=0.5, min_samples=5),
            "Gaussian Mixture": GaussianMixture(n_components=n_clusters, random_state=42),
            "Mean Shift": MeanShift(),
            "Birch Clustering": Birch(n_clusters=n_clusters),
            "Spectral Clustering": SpectralClustering(n_clusters=n_clusters, random_state=42)
        }

        # Apply each clustering algorithm and visualize the results
        for name, model in algorithms.items():
            if hasattr(model, 'fit_predict'):
                labels = model.fit_predict(X)
            elif hasattr(model, 'fit'):
                model.fit(X)
                if hasattr(model, 'labels_'):
                    labels = model.labels_
                else:
                    labels = model.predict(X)

            df[f'{name}_cluster'] = labels

            # Print cluster statistics
            print(f"Model: {name}")
            print(df[f'{name}_cluster'].value_counts())
            print("\n")

            # Plot the clustering results
            plt.figure(figsize=(8, 6))
            scatter = plt.scatter(X_reduced[:, 0], X_reduced[:, 1], c=labels, cmap='viridis', s=50, alpha=0.7)
            plt.colorbar(scatter)
            plt.title(f"Clustering Results: {name}")
            plt.xlabel("Component 1" if X.shape[1] > 2 else df.columns[0])
            plt.ylabel("Component 2" if X.shape[1] > 2 else df.columns[1])
            plt.grid(True)
            plt.show()

        return df
    except Exception as e:
        print(f"Error during unsupervised learning: {e}")
        raise


def MachineLearning_Reinforcement_Learning(df):
    """
    A basic example function to introduce a reinforcement learning setup using a given DataFrame.

    Parameters:
    df (pandas.DataFrame): The DataFrame containing the data to train and test on.
    """
    # Check if DataFrame is valid and has numeric data for learning
    if df.empty:
        print("The DataFrame is empty.")
        return

    numeric_cols = df.select_dtypes(include=['number']).columns
    if numeric_cols.size == 0:
        print("The DataFrame does not have any numeric columns for reinforcement learning.")
        return

    # Set up the environment as the DataFrame's statistics or as a custom environment
    print("Reinforcement Learning Setup:")
    print("\nNumeric columns available for learning:")
    print(numeric_cols)

    # Create a simple environment using a random policy for demonstration purposes
    state_space = len(numeric_cols)
    action_space = 3  # e.g., 0 = 'do nothing', 1 = 'increase', 2 = 'decrease'

    # Initialize Q-table with zeros
    Q = np.zeros((state_space, action_space))

    # Define hyperparameters
    learning_rate = 0.1  # Alpha
    discount_factor = 0.9  # Gamma
    exploration_rate = 1.0  # Epsilon
    exploration_decay = 0.995
    min_exploration_rate = 0.01

    # Simulate the learning process over a set number of episodes
    num_episodes = 1000
    for episode in range(num_episodes):
        state = random.randint(0, state_space - 1)
        done = False

        while not done:
            # Exploration vs. exploitation
            if np.random.uniform(0, 1) < exploration_rate:
                action = random.randint(0, action_space - 1)  # Explore
            else:
                action = np.argmax(Q[state, :])  # Exploit

            # Simulate reward based on action (e.g., randomly generated for simplicity)
            reward = np.random.uniform(-1, 1)

            # Calculate next state (using state transition logic)
            next_state = (state + 1) % state_space  # Example transition logic

            # Q-learning update rule
            Q[state, action] = (1 - learning_rate) * Q[state, action] + \
                               learning_rate * (reward + discount_factor * np.max(Q[next_state, :]))

            # Move to the next state and check if we are done
            state = next_state
            done = True if episode == num_episodes - 1 else False

        # Decay exploration rate
        exploration_rate = max(min_exploration_rate, exploration_rate * exploration_decay)

    print("Training complete.")

    # Display Q-table
    print("\nTrained Q-Table:")
    print(Q)

    # Plot Q-values for visualization (optional)
    plt.figure(figsize=(12, 6))
    plt.title("Q-Values Heatmap")
    sns.heatmap(Q, annot=True, cmap='coolwarm', linewidths=0.5)
    plt.xlabel("Actions")
    plt.ylabel("States")
    plt.show()


# 4. Deep Learning
def DeepLearning_models(df, target_col='amount', epochs=50, batch_size=32):
    """
    Train, evaluate, and visualize multiple deep learning regression models with different architectures.
    """
    try:

        # Preprocess data
        df = convert_datetime_columns(df)
        df = encode_categorical_columns(df)
        df = df.apply(pd.to_numeric, errors='coerce').fillna(df.mean())

        X = df.drop(target_col, axis=1)
        y = df[target_col]

        # Split the data into training and testing sets
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # One-hot encode categorical columns
        categorical_cols = [col for col in X.columns if X[col].dtype == 'int64' or X[col].dtype == 'object']
        X_train = pd.get_dummies(X_train, columns=categorical_cols, drop_first=True)
        X_test = pd.get_dummies(X_test, columns=categorical_cols, drop_first=True)

        # Align columns
        X_train, X_test = X_train.align(X_test, join='left', axis=1, fill_value=0)

        # Normalize data
        scaler = StandardScaler()
        X_train = scaler.fit_transform(X_train)
        X_test = scaler.transform(X_test)

        # List of neural network architectures
        architectures = {
            "Simple Neural Network": models.Sequential([
                Dense(64, activation='relu'),
                Dense(1)  # Output layer for regression
            ]),
            "Deep Neural Network": models.Sequential([
                Dense(128, activation='relu'),
                Dense(64, activation='relu'),
                Dense(32, activation='relu'),
                Dense(1)
            ]),
            "Neural Network with Dropout": models.Sequential([
                Dense(128, activation='relu'),
                Dropout(0.3),
                Dense(64, activation='relu'),
                Dense(1)
            ]),
            "Neural Network with Batch Normalization": models.Sequential([
                Dense(128, activation='relu'),
                Dense(64, activation='relu'),
                Dense(32, activation='relu'),
                Dense(1)
            ]),
            "Shallow Neural Network": models.Sequential([
                Dense(32, activation='relu'),
                Dense(1)
            ]),
            "Neural Network with Multiple Layers and Dropout": models.Sequential([
                Dense(256, activation='relu'),
                Dropout(0.5),
                Dense(128, activation='relu'),
                Dropout(0.5),
                Dense(64, activation='relu'),
                Dense(1)
            ])
        }

        # Train and evaluate each model
        for name, model in architectures.items():
            model.compile(optimizer=Adam(learning_rate=0.001), loss='mean_squared_error', metrics=['mae'])
            history = model.fit(X_train, y_train, validation_split=0.2, epochs=epochs, batch_size=batch_size, verbose=1)

            # Evaluate the model
            test_loss, test_mae = model.evaluate(X_test, y_test, verbose=0)
            print(f"Model: {name}")
            print(f"Test Loss (MSE): {test_loss:.2f}")
            print(f"Test MAE: {test_mae:.2f}\n")

            # Predict and visualize
            predictions = model.predict(X_test).flatten()

            # Scatter plot: Actual vs. Predicted
            plt.figure(figsize=(8, 6))
            plt.scatter(y_test, predictions, alpha=0.7, edgecolor='k')
            plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--')  # Reference line
            plt.title(f"{name} (MAE: {test_mae:.2f})")
            plt.xlabel("Actual Values")
            plt.ylabel("Predicted Values")
            plt.grid(True)
            plt.show()

            # Loss Curve
            plt.figure(figsize=(8, 6))
            plt.plot(history.history['loss'], label='Training Loss')
            plt.plot(history.history['val_loss'], label='Validation Loss')
            plt.title(f"{name} Loss Curve")
            plt.xlabel("Epoch")
            plt.ylabel("Loss (MSE)")
            plt.legend()
            plt.grid(True)
            plt.show()

    except Exception as e:
        print(f"Error in deep learning example: {e}")
        raise


# 5. Big Data Tools
def BigData(file_path):
    """
    Process large datasets efficiently using Dask and pandas with chunking for big data.
    """
    try:
        # Enable Dask progress bar for visual feedback
        ProgressBar().register()

        # Load the data using Dask for handling large CSVs efficiently
        ddf = dd.read_csv(file_path, assume_missing=True)

        # Display basic information and statistics
        print("Initial Dataset Info:")
        print(ddf.head(), "\n")

        # Identify numeric columns for filling NaN values
        numeric_cols = ddf.select_dtypes(include=['number']).columns

        # Use map_partitions to fill NaN values in numeric columns with their mean
        ddf = ddf.map_partitions(lambda df: df.fillna(df[numeric_cols].mean()), meta=ddf._meta)

        # Example: Filtering rows based on a condition (e.g., values greater than a threshold)
        ddf_filtered = ddf[ddf['Balance'] > 100]  # Replace 'amount' with your actual column

        # Perform operations on the filtered data
        ddf_filtered['processed_column'] = ddf_filtered['Balance'] * 1.1  # Sample transformation

        # Compute the results and convert to a pandas DataFrame for final processing
        result_df = ddf_filtered.compute()

        # Save processed data to a CSV or other formats
        result_df.to_csv('processed_data.csv', index=False)

        print("Big data processing completed successfully. Processed data saved as 'processed_data.csv'.")

    except Exception as e:
        print(f"Error during big data processing: {e}")
        raise


# 6. Data Visualization
def DataVisualization(df):
    """
    Generates a set of visualizations for the given DataFrame.

    Parameters:
    df (pandas.DataFrame): The DataFrame containing the data to visualize.
    """
    # Set the aesthetics for the plots
    sns.set(style="whitegrid")

    # Display basic information about the DataFrame
    print("DataFrame Info:")
    print(df.info())

    # Display the first few rows of the DataFrame
    print("\nDataFrame Head:")
    print(df.head())

    # Identify numeric columns
    numeric_cols = df.select_dtypes(include=['number']).columns

    # Plot histograms for numeric columns with handling for NaN, inf, or non-numeric data
    for col in numeric_cols:
        # Convert column to numeric, replacing non-numeric with NaN
        df[col] = pd.to_numeric(df[col], errors='coerce')
        # Drop rows with NaN values in the current column
        df = df.dropna(subset=[col])
        # Remove any infinite values
        df = df[np.isfinite(df[col])]

        # Check if the column is now empty after cleaning
        if df[col].empty:
            print(f"Column '{col}' is empty after cleaning and will be skipped.")
            continue

        # Plotting the histogram
        try:
            plt.figure(figsize=(10, 5))
            sns.histplot(df[col], kde=True)
            plt.title(f'Distribution of {col}')
            plt.xlabel(col)
            plt.ylabel('Frequency')
            plt.show()
        except Exception as e:
            print(f"Error while plotting '{col}': {e}")

            # Plot a bar chart for categorical columns' value counts
    categorical_cols = df.select_dtypes(include=['object']).columns
    for col in categorical_cols:
        plt.figure(figsize=(10, 5))
        sns.countplot(data=df, x=col, order=df[col].value_counts().index)
        plt.title(f'Value Counts for {col}')
        plt.xlabel(col)
        plt.ylabel('Count')
        plt.xticks(rotation=45)
        plt.show()


if __name__ == "__main__":
    # Example usage
    query = 'SELECT * FROM "IntegratedDataWarehouse";'
    data = load_data_from_db(query)
    if not data.empty:
        data = clean_data(data)
        data = feature_engineering(data)
        DataAnalysis(data)
        MachineLearning_Supervised_learning_models(data)
        MachineLearning_UN_Supervised_learning_models(data)
        MachineLearning_Reinforcement_Learning(data)
        DeepLearning_models(data)
        BigData("user_data_100_extended.csv")
        DataVisualization(data)
