import { defineConfig } from 'vitepress'
import { getGuideSideBarItems } from './guide'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "ANDROID-XIAOZHI",
  description: "android-xiaozhi là một ứng dụng khách nhỏ thông minh đa nền tảng dựa trên Flutter, hỗ trợ iOS, Android, Web và nhiều nền tảng khác",
  base: '/xiaozhi-android-client/',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Trang chủ', link: '/' },
      { text: 'Hướng dẫn', link: '/guide/00_文档目录' },
      { text: 'Hệ sinh thái liên quan', link: '/ecosystem/' },
      { text: 'Hướng dẫn đóng góp', link: '/contributing' },
      { text: 'Người đóng góp đặc biệt', link: '/contributors' },
      { text: 'Tài trợ', link: '/sponsors/' }
    ],

    sidebar: {
      '/guide/': [
        {
          text: 'Hướng dẫn',
          // Mở rộng mặc định
          collapsed: false,
          items: getGuideSideBarItems(),
        }
      ],
      '/ecosystem/': [
        {
          text: 'Tổng quan hệ sinh thái',
          link: '/ecosystem/'
        },
        {
          text: 'Dự án liên quan',
          collapsed: false,
          items: [
            { text: 'Phía Python của XiaoZhi', link: '/ecosystem/projects/py-xiaozhi/' },
            { text: 'xiaozhi-esp32-server', link: '/ecosystem/projects/xiaozhi-esp32-server/' }
          ]
        },
        // {
        //   text: 'Tài nguyên và hỗ trợ',
        //   collapsed: true,
        //   items: [
        //     { text: 'Phần mở rộng và plugin chính thức', link: '/ecosystem/resources/official-extensions/' },
        //     { text: 'Đóng góp cộng đồng', link: '/ecosystem/resources/community-contributions/' },
        //     { text: 'Thiết bị tương thích', link: '/ecosystem/resources/compatible-devices/' }
        //   ]
        // }
      ],
      // Trang tài trợ không hiển thị thanh bên
      '/sponsors/': [],
      // Trang hướng dẫn đóng góp không hiển thị thanh bên
      '/contributing': [],
      // Trang danh sách người đóng góp không hiển thị thanh bên
      '/contributors': [],
      // Trang kiến trúc hệ thống không hiển thị thanh bên
      '/architecture/': []
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/TOM88812/xiaozhi-android-client' }
    ]
  }
})
