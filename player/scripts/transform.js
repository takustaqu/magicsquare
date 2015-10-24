//transform

function setTransform($el,points,relative) {

	if(!$el.attr("data-transform-origins")){
		var origin = [
			[0, 0],
			[$el.width(), 0],
			[$el.width(), $el.height()],
			[0, $el.height()]
		];
		$el.attr("data-transform-origins",JSON.stringify(origin));
	}else{
		// console.log($el.attr("data-transform-origins"));
		var origin = JSON.parse($el.attr("data-transform-origins"));
	}

	if(relative){
		points[1][0] = points[1][0] + $el.width();
		points[2][0] = points[2][0] + $el.width();
		points[2][1] = points[2][1] + $el.height();
		points[3][1] = points[3][1] + $el.height();
	}

	console.log(points);

	/*
		1.left-top
		2.right-top
		3.right-bottom
		4.left-top
	*/

	var M = [], V = [] , x, y, X, Y,i;
	for(i=0;i<4;i++) {
	    x = origin[i][0];
	    y = origin[i][1];
	    X = points[i][0];
	    Y = points[i][1];
	    M.push([x, y, 1, 0, 0, 0, -x*X, -y*X]);
	    M.push([0, 0, 0, x, y, 1, -x*Y, -y*Y]);
	    V.push(X);
	    V.push(Y);
	}
	var ans = $M(M).inv().x($V(V));
	var transform = "perspective(1px)scaleZ(-1)translateZ(-1px)matrix3d(" +
	    ans.e(1) + ',' + ans.e(4) + ',' + ans.e(7) + ',0,' +
	    ans.e(2) + ',' + ans.e(5) + ',' + ans.e(8) + ',0,' +
	    ans.e(3) + ',' + ans.e(6) + ',1,0,' +
	    '0,0,0,1)translateZ(1px)';

	$el.css({'-webkit-transform': transform,"-webkit-transform-origin":"0% 0%"});

}
