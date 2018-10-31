import Vue from 'vue/dist/vue.esm';
import Foom from '../../foom.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#fooms',
    components: { Foom }
  })
})
