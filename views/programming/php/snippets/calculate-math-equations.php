function calc($equation){
	//Remove whitespaces
	$equation = preg_replace('/\s+/', '', $equation);
	echo "$equation\n";
	
	//What is a number
	$number = '((?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?|pi|π)';
	//Allowed PHP functions
	$functions = '(?:sinh?|cosh?|tanh?|acosh?|asinh?|atanh?|exp|log(10)?|deg2rad|rad2deg|sqrt|pow|abs|intval|ceil|floor|round|(mt_)?rand|gmp_fact)';
	//Allowed math operators
	$operators = '[\/*\^\+-,]';
	//Final regexp, heavily using recursive patterns
	$regexp = '/^([+-]?('.$number.'|'.$functions.'\s*\((?1)+\)|\((?1)+\))(?:'.$operators.'(?1))?)+$/';
	
	if(preg_match($regexp, $equation)){
		//Replace pi with pi function
		$equation = preg_replace('!pi|π!', 'pi()', $equation);
		echo "$equation\n";
		eval('$result = '.$equation.';');
	}else{
		$result = false;
	}
	return $result;
}