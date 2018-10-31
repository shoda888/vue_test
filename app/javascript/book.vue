<template>
  <div class="booklist">
    <div id="app" @click="getBooktitle">
      <p>{{ message }}</p>
    </div>
    <div class="container" v-show="openBool">
      <div class="row">
        <div class="col s4 m6" v-for="list in titleLists">
          <div class="card">
            <span class='card-title'@click="setBookInfo(list.id)">{{list.title}}</span>
          </div>
        </div>
        <div class="row" v-show="bookInfoBool">
          <div class="col s12 m12">
            <div class="card blue-grey darken-1">
              <div class="card-content white-text">
                <span class='card-title'>
                  {{ bookInfo.title }}
                </span>
                <div class="detail">
                  {{ bookInfo.author }}
                </div>
                <div class="detail">
                  {{ bookInfo.publisher }}
                </div>
                <div class="detail">
                  {{ bookInfo.genre }}
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>

    </div>
  </div>

</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import axios from 'axios';
  export default {
    data: function () {
      return {
        message: "Hello Vue!",
        bookInfoBool: false,
        openBool: false,
        bookInfo: {},
        titleLists: {}
      }
    },
    methods: {
      setBookInfo(id){
        axios.get(`api/books/${id}.json`)
          .then(res => {
            console.log(res);
            this.bookInfo = res.data;
            this.bookInfoBool = true;
          });
      },
      getBooktitle(){
        axios.get(`api/books.json`)
          .then(res => {
            console.log(res);
            this.titleLists = res.data;
            this.openBool = true;
          });
      }
    }
  }
</script>

<style scoped>

</style>
