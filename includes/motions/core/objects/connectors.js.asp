<script>
/* SVG Connectors — 조직 관계선 DOM 구성 */
var Connectors = {
  mountPair: function(canvas, options){
    options = options || {};
    if(!canvas) return null;

    var svgNS = 'http://www.w3.org/2000/svg';
    var svg = document.createElementNS(svgNS, 'svg');
    svg.setAttribute('id', options.id || 'lo-connectors');
    svg.setAttribute('viewBox', '0 0 100 100');
    svg.setAttribute('preserveAspectRatio', 'none');

    var canvasH = canvas.clientHeight || canvas.offsetHeight || 500;
    var y1Start = 40 - (20 / canvasH) * 100;
    var y1 = String(y1Start);

    var left = document.createElementNS(svgNS, 'line');
    left.setAttribute('id', 'connector-left');
    left.setAttribute('x1', '50');
    left.setAttribute('y1', y1);
    left.setAttribute('x2', '22');
    left.setAttribute('y2', '68');
    svg.appendChild(left);

    var right = document.createElementNS(svgNS, 'line');
    right.setAttribute('id', 'connector-right');
    right.setAttribute('x1', '50');
    right.setAttribute('y1', y1);
    right.setAttribute('x2', '78');
    right.setAttribute('y2', '68');
    svg.appendChild(right);

    canvas.appendChild(svg);
    return svg;
  }
};
</script>
