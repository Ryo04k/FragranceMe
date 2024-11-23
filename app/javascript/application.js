// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

document.addEventListener("turbo:click", (event) => {
    if (event.target.closest('.pagination')) {
        window.scroll({
            top: 0,
            behavior: 'smooth'
        });
    }
});
