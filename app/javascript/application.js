// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import Rails from "@rails/ujs"
import "./side_navigation"
Rails.start()

document.addEventListener("turbo:click", (event) => {
    if (event.target.closest('.pagination')) {
        window.scroll({
            top: 0,
        });
    }
});

// フラッシュメッセージの表示切り替え
document.addEventListener("turbo:load", () => {
  const flashMessage = document.getElementById('flash-message');

  const fadeOutFlashMessage = (element) => {
    element.style.opacity = '0';
    setTimeout(() => {
      element.style.display = 'none';
    }, 500);
  };

  setTimeout(() => {
    fadeOutFlashMessage(flashMessage);
  }, 3000);
});