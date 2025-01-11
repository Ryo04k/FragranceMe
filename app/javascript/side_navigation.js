document.addEventListener('turbo:load', function() {
//サイドバー要素の取得
const sidebar = document.getElementById('default-sidebar');
// サイドバー内の<li>要素を取得
const items = sidebar.querySelectorAll('li');

// メニュー内のテキスト表示・非表示を制御
const toggleTextVisibility = (isVisible) => {
  items.forEach(item =>{
    const text = item.querySelector('span:nth-child(2)');
    if (text) {
      text.classList.toggle('text-visible', isVisible);
    }
  });
};

// メニュー開閉時にサイドバーの幅を切り替え
const toggleSidebarWidth = (isExpanded) => {
  sidebar.classList.toggle('w-48', isExpanded);
  sidebar.classList.toggle('w-16', !isExpanded);
}

// サイドバーにマウスが乗った時
const handleMouseEnter = () => {
  toggleTextVisibility(true);
  toggleSidebarWidth(true);
};

// サイドバーからマウスが離れた時
const handleMouseLeave = () => {
  toggleTextVisibility(false);
  toggleSidebarWidth(false);
};

sidebar.addEventListener('mouseenter', handleMouseEnter);
sidebar.addEventListener('mouseleave', handleMouseLeave);
});
