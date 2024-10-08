<script setup>
import { useTheme } from 'vuetify'
import VerticalNavSectionTitle from '@/@layouts/components/VerticalNavSectionTitle.vue'
import upgradeBannerDark from '@images/pro/upgrade-banner-dark.png'
import upgradeBannerLight from '@images/pro/upgrade-banner-light.png'
import VerticalNavLayout from '@layouts/components/VerticalNavLayout.vue'
import VerticalNavLink from '@layouts/components/VerticalNavLink.vue'

// Components
import Footer from '@/layouts/components/Footer.vue'
import NavbarThemeSwitcher from '@/layouts/components/NavbarThemeSwitcher.vue'
import UserProfile from '@/layouts/components/UserProfile.vue'

const vuetifyTheme = useTheme()

const upgradeBanner = computed(() => {
  return vuetifyTheme.global.name.value === 'light' ? upgradeBannerLight : upgradeBannerDark
})
</script>

<template>
  <VerticalNavLayout>
    <!-- 👉 navbar -->
    <template #navbar="{ toggleVerticalOverlayNavActive }">
      <div class="d-flex h-100 align-center">
        <!-- 👉 Vertical nav toggle in overlay mode -->
        <IconBtn
          class="ms-n3 d-lg-none"
          @click="toggleVerticalOverlayNavActive(true)"
        >
          <VIcon icon="bx-menu" />
        </IconBtn>

        <!--  Searchbar hidden
        <div
          class="d-flex align-center cursor-pointer"
          style="user-select: none;"
        >
          <IconBtn>
            <VIcon icon="bx-search" />
          </IconBtn>

          <span class="d-none d-md-flex align-center text-disabled">
            <span class="me-3">Search</span>
            <span class="meta-key">&#8984;K</span>
          </span>
        </div>
        -->
        <VSpacer />

        <IconBtn
          class="me-2"
          href="https://github.com/spina95/finance-tracker"
          target="_blank"
          rel="noopener noreferrer"
        >
          <VIcon icon="bxl-github" />
        </IconBtn>

        <NavbarThemeSwitcher class="me-2" />

        <UserProfile />
      </div>
    </template>

    <template #vertical-nav-content>

      <!-- 👉 User Interface -->
      <VerticalNavSectionTitle
        :item="{
          heading: 'Personal',
        }"
      />

      <VerticalNavLink
        :item="{
          title: 'Journal',
          icon: 'bx-book-heart',
          to: '/personal/journal',
        }"
      />
      
      <!-- 👉 User Interface -->
      <VerticalNavSectionTitle
        :item="{
          heading: 'Finance',
        }"
      />

      <VerticalNavLink
        :item="{
          title: 'Dashboard',
          icon: 'bx-home',
          to: '/finance/dashboard',
        }"
      />

      <VerticalNavLink
        :item="{
          title: 'Expenses',
          icon: 'mdi-cash-multiple',
          to: '/finance/expenses',
        }"
      />
      <VerticalNavLink
        :item="{
          title: 'Incomes',
          icon: 'mdi-bank',
          to: '/finance/incomes',
        }"
      />

      <VerticalNavSectionTitle
        :item="{
          heading: 'Investments',
        }"
      />

      <VerticalNavLink
        :item="{
          title: 'My products',
          icon: 'mdi-finance',
          to: '/investments/products',
        }"
      />

      <VerticalNavLink
        :item="{
          title: 'Portfolio',
          icon: 'mdi-chart-pie',
          to: '/investments/portfolio',
        }"
      />

      <!--
        
      
      <VerticalNavSectionTitle
        :item="{
          heading: 'Settings',
        }"
      />

      <VerticalNavLink
        :item="{
          title: 'Account Settings',
          icon: 'mdi-account-cog-outline',
          to: '/account-settings',
        }"
      />
      */

      <VerticalNavSectionTitle
        :item="{
          heading: 'Pages',
        }"
      />

      <VerticalNavLink
        :item="{
          title: 'Dashboard',
          icon: 'bx-home',
          to: '/dashboard',
        }"
      />

      <VerticalNavLink
        :item="{
          title: 'Login',
          icon: 'bx-log-in',
          to: '/login',
        }"
      />
      <VerticalNavLink
        :item="{
          title: 'Register',
          icon: 'bx-user-plus',
          to: '/register',
        }"
      />
      <VerticalNavLink
        :item="{
          title: 'Error',
          icon: 'bx-info-circle',
          to: '/no-existence',
        }"
      />

      <VerticalNavSectionTitle
        :item="{
          heading: 'User Interface',
        }"
      />
      
      <VerticalNavLink
        :item="{
          title: 'Typography',
          icon: 'mdi-alpha-t-box-outline',
          to: '/typography',
        }"
      />
      <VerticalNavLink
        :item="{
          title: 'Icons',
          icon: 'bx-show',
          to: '/icons',
        }"
      />
      <VerticalNavLink
        :item="{
          title: 'Cards',
          icon: 'bx-credit-card',
          to: '/cards',
        }"
      />
      <VerticalNavLink
        :item="{
          title: 'Tables',
          icon: 'bx-table',
          to: '/tables',
        }"
      />
      <VerticalNavLink
        :item="{
          title: 'Form Layouts',
          icon: 'mdi-form-select',
          to: '/form-layouts',
        }"
      />
      -->

    </template>

    <template #after-vertical-nav-items>
      <!-- 👉 illustration -->
      <a
        href="https://themeselection.com/item/sneat-vuetify-vuejs-admin-template"
        target="_blank"
        rel="noopener noreferrer"
        style="margin-left: 7px;"
      >
  
      </a>
    </template>
    

    <!-- 👉 Pages -->
    <slot />

    <!-- 👉 Footer -->
    <template #footer>
      
    </template>
  </VerticalNavLayout>
</template>

<style lang="scss" scoped>
.meta-key {
  border: thin solid rgba(var(--v-border-color), var(--v-border-opacity));
  border-radius: 6px;
  block-size: 1.5625rem;
  line-height: 1.3125rem;
  padding-block: 0.125rem;
  padding-inline: 0.25rem;
}
</style>
