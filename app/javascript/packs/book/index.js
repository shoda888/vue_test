import Vue from 'vue/dist/vue.esm';
import Book from '../../book.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#books',
    components: { Book }
  })
})
