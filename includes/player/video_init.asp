<script>
/* closePlayer — video_controller_bottom.asp에서 window에 등록 */
(function(){
  var back = document.getElementById('lo-back');
  if(back && typeof closePlayer === 'function' && !back.getAttribute('onclick')){
    back.onclick = closePlayer;
  }
})();
</script>
