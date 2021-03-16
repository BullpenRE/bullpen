// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("jquery")
require("@fortawesome/fontawesome-free/js/all")
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("bootstrap")
require("bootstrap-select")
require("select2")
require("typeface-nunito-sans")
require("typeface-ubuntu")
require("trix")
require("@rails/actiontext")
require("packs/filter_talent")

import 'src/stylesheets/application'
const images = require.context('../images', true)

import $ from "jquery"
document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
})

import * as bootstrapValidate from 'bootstrap-validate';
window.bootstrapValidate = bootstrapValidate;

import Swal from 'sweetalert2/dist/sweetalert2.js'
import 'sweetalert2/src/sweetalert2.scss'
window.Swal = Swal;

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import 'images/icons8-search-659.png';
import 'images/bg-user-img.png';
import 'images/linked-job-not-found.png';
