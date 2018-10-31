<template>
  <div>
    {{message}}
    <div class="input-field">
      <select v-model='selected_title' @change="fetchAuthors">
        <option v-for="(value, key) in titleLists" v-bind:value="value">{{key}}</option>
      </select>
      <label for="book_title">タイトル</label>
    </div>
    <div class="input-field">
      <select v-model='selected_author'>
        <option v-for="(value, key) in authorLists" v-bind:value="value">{{key}}</option>
      </select>
      <label for="book_author">著者</label>
    </div>
  </div>

</template>

<script>
  console.log('here is bookstore')

  console.log('here is bookstore')
  import Vue from 'vue/dist/vue.esm';

  export default {
    props: ['title', 'author'],
    data: function () {
      return {
        message: 'うえｒｇｈふぃおうｒｈふぉふぉいｆｆｈ',
        selected_title: this.title,
        selected_author: this.author,
        titleLists: {"選択してください": "", 'ABC': 'ABC', 'DEF': 'DEF', 'GHI': 'GHI'},
        authorLists: {"選択してください": "", 'au1': 'au1', 'au2': 'au2', 'au3': 'au3'}
      }
    },
    methods: {
      fetchAuthors(){
        var tmp_authorLists = {};
        switch (this.selected_title){
          case 'ABC':
          console.log('ABC');
            tmp_authorLists = {"数学系": "数学系", "物理学系": "物理学系", "化学系": "化学系", "地球惑星科学系": "地球惑星科学系"}
            break;
          case 'DEF':
            tmp_authorLists = {"機械系": "機械系", "システム制御系": "システム制御系", "電気電子系": "電気電子系", "情報通信系": "情報通信系", "経営工学系": "経営工学系"}
            break;
          case 'GHI':
            tmp_authorLists = {"材料系": "材料系", "応用科学系": "応用科学系"}
            break;
        }
        this.authorLists = tmp_authorLists;
      }
    }
  }
</script>

<style scoped>

</style>
