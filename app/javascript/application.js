// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import Rails from "@rails/ujs"
Rails.start()

document.addEventListener("turbo:click", (event) => {
    if (event.target.closest('.pagination')) {
        window.scroll({
            top: 0,
        });
    }
});
