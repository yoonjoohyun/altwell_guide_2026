<script>
/* closePlayer — video_controller_bottom.asp에서 window에 등록 */
(function(){
  var back = document.getElementById('lo-back');
  if(back && typeof closePlayer === 'function' && !back.getAttribute('onclick')){
    back.onclick = closePlayer;
  }
})();

/* 7×7 존 그리드 라벨 (a1–g7) */
(function(){
  var grid = document.getElementById('motion-zone-grid');
  if(!grid || grid.childElementCount) return;
  var rows = 'abcdefg';
  for(var r = 0; r < 7; r++){
    for(var c = 1; c <= 7; c++){
      var cell = document.createElement('span');
      cell.className = 'motion-zone-cell';
      cell.textContent = rows.charAt(r) + c;
      grid.appendChild(cell);
    }
  }
})();
</script>
