import debounce from "lodash.debounce";

document
  .getElementById("search-field-big")
  .addEventListener("keydown", debounce(searchQuotes, 300));

function searchQuotes() {
  const searchString = document.getElementById("search-field-big").value;
  if (searchString.length > 0) {
    // const params = {search_string: searchString}
    // let url = new URL(window.location.href);
    // url.search = new URLSearchParams(params).toString();
    // console.log(url.href)
    // console.log(`${window.location.href}?search_string=${searchString}`);
    const url = `${window.location.href}?search_string=${searchString}`;
    fetch(url);
  }

  console.log();
  // console.log(document.getElementById("search-field-big").value.length);
};
