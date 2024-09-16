import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', redirect: '/finance/dashboard' },
    {
      path: '/',
      component: () => import('../layouts/default.vue'),
      children: [
        {
          path: 'personal/journal',
          component: () => import('../pages/personal/Journal.vue'),
        },
        {
          path: 'personal/journal/:id',
          component: () => import('../pages/personal/JournalDetail.vue'),
        },
        {
          path: 'finance/dashboard',
          component: () => import('../pages/finance/dashboard.vue'),
        },
        {
          path: 'dashboard',
          component: () => import('../pages/dashboard-demo.vue'),
        },
        {
          path: 'finance/expenses',
          component: () => import('../pages/finance/expenses.vue'),
        },
        {
          path: 'finance/incomes',
          component: () => import('../pages/finance/incomes.vue'),
        },
        {
          path: 'investments/products',
          component: () => import('../pages/investments/products.vue'),
        },
        {
          path: 'investments/products/:id',
          component: () => import('../pages/investments/product-details.vue'),
        },
        {
          path: 'investments/new-product',
          component: () => import('../pages/investments/new-product.vue'),
        },
        {
          path: 'account-settings',
          component: () => import('../pages/account-settings.vue'),
        },
        {
          path: 'typography',
          component: () => import('../pages/typography.vue'),
        },
        {
          path: 'icons',
          component: () => import('../pages/icons.vue'),
        },
        {
          path: 'cards',
          component: () => import('../pages/cards.vue'),
        },
        {
          path: 'tables',
          component: () => import('../pages/tables.vue'),
        },
        {
          path: 'form-layouts',
          component: () => import('../pages/form-layouts.vue'),
        },
      ],
    },
    {
      path: '/',
      component: () => import('../layouts/blank.vue'),
      children: [
        {
          path: 'login',
          component: () => import('../pages/login.vue'),
        },
        {
          path: 'register',
          component: () => import('../pages/register.vue'),
        },
        {
          path: '/:pathMatch(.*)*',
          component: () => import('../pages/[...all].vue'),
        },
      ],
    },
  ],
})

export default router
