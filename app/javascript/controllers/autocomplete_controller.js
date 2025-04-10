import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static values = { url: String }
  static targets = ["input", "results"]

  connect() {
    if (!this.hasInputTarget) return;
    this.inputTarget.addEventListener("input", this.search.bind(this));
  }

async search() {

  const query = this.inputTarget.value.trim();

  if (query.length < 2){
    this.resultsTarget.innerHTML = "";
    return;
  }

  try {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
    const items = await response.json();

    this.resultsTarget.innerHTML = items.map(item =>
      `<li class="cursor-pointer hover:bg-gray-100 p-2" data-action="click->autocomplete#select" data-id="${item.id}">${item.name}</li>`
    ).join("");

  } catch (error) {
    console.error("search中にエラーが発生しました", error);
  }
}

select(event) {
  this.inputTarget.value = event.currentTarget.textContent;
  this.resultsTarget.innerHTML = "";
}
}
