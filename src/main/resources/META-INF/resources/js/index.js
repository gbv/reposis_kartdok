document.addEventListener('DOMContentLoaded', async () => {
  document.getElementById('kartdok-searchMainPage')?.addEventListener('submit', ignoreEmptyFieldsOnSubmit);
});
