from rest_framework.routers import DefaultRouter
from .views import CustomUserViewSet, TransactionViewSet, VirtualCardViewSet

router = DefaultRouter()
router.register(r'users', CustomUserViewSet)
router.register(r'transactions', TransactionViewSet)
router.register(r'virtual-cards', VirtualCardViewSet)

urlpatterns = router.urls
