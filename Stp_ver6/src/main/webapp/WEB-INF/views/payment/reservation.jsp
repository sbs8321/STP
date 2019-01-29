`<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

</head>
<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.js"></script>

<script>
	//포인트 잔액 확인하기
	function pointCheck() {
		var reserveCharge = document.getElementById('reserveCharge').value;
		$.ajax({
			type : "post",
			url : "../payment/pointCheck",
			dataType : "text",
			data : {
				"email" : "${sessionScope.loginID }"
			},
			success : function(data) {
				if (data != "0") {
					document.getElementById('pointBalance').value = data;

					//point가 예약한 금액보다 많으면 포인트 사용 버튼 / 결제 버튼 생성
					var balance = document.getElementById('pointBalance').value
					if (Number(reserveCharge) <= Number(balance)) {
						$(".pointUse").show();
					} else {
						$(".payUse").show();
					}
				} else {//그렇지 않으면 결제버튼 / 충전하기  생성
					document.getElementById('pointBalance').value = 0;
					$(".payUse").show();
				}

			}

		});
	}

	//포인트 사용하기 버튼
	function pointUse() {
		var parkingName = document.getElementById('parkingName').value;
		var balance = document.getElementById('reserveCharge').value;

		//POST 방식
		var form = document.createElement("form");
		form.setAttribute("charset", "UTF-8");
		form.setAttribute("method", "POST");
		form.setAttribute("action", "../payment/pointUse");
		/* input 태그 만들기 */

		var hiddenValue = document.createElement("input");
		hiddenValue.setAttribute("type", "hidden");
		hiddenValue.setAttribute("name", "balance");
		hiddenValue.setAttribute("value", balance);
		form.appendChild(hiddenValue);

		var hiddenValue = document.createElement("input");
		hiddenValue.setAttribute("type", "hidden");
		hiddenValue.setAttribute("name", "parkingName");
		hiddenValue.setAttribute("value", parkingName);
		form.appendChild(hiddenValue);

		document.body.appendChild(form);

		if (confirm(balance + "point 사용하시겠습니까?") == true) {
			/* 자동 submit */
			form.submit();
		} else {
			alert('포인트 사용을 취소했습니다. 다시 시도하세요.');
			return;
		}

	}

	//결제하기 버튼
	function payUse() {

		var parkingName = document.getElementById('parkingName').value;
		var balance = document.getElementById('reserveCharge').value;

		//POST 방식
		var form = document.createElement("form");
		form.setAttribute("charset", "UTF-8");
		form.setAttribute("method", "POST");
		form.setAttribute("action", "../payment/payUse");
		/* input 태그 만들기 */

		var hiddenValue = document.createElement("input");
		hiddenValue.setAttribute("type", "hidden");
		hiddenValue.setAttribute("name", "balance");
		hiddenValue.setAttribute("value", balance);
		form.appendChild(hiddenValue);

		var hiddenValue = document.createElement("input");
		hiddenValue.setAttribute("type", "hidden");
		hiddenValue.setAttribute("name", "parkingName");
		hiddenValue.setAttribute("value", parkingName);
		form.appendChild(hiddenValue);

		document.body.appendChild(form);

		if (confirm(balance + "원 결제하시겠습니까?") == true) {
			var myForm = form;
			var url = "../payment/payUse";
			window
					.open(
							"",
							"form",
							"toolbar=no, width=540, height=800, directories=no, status=no,    scrollorbars=no, resizable=no");
			myForm.action = url;
			myForm.method = "post";
			myForm.target = "form";
			myForm.submit();

		} else {
			alert('결제를 취소했습니다. 다시 시도하세요.');
			return;
		}
	}
	//포인트 충전하기
	function pointCharge(){
		//POST 방식
		var form = document.createElement("form");
		form.setAttribute("charset", "UTF-8");
		form.setAttribute("method", "POST");
		form.setAttribute("action", "../payment/pointCharge");
		/* input 태그 만들기 */

		document.body.appendChild(form);
		
		var myForm = form;
		var url = "../payment/pointCharge";
		 window.open("" ,"form", 
		       "toolbar=no, width=540, height=800, directories=no, status=no,    scrollorbars=no, resizable=no"); 
		 myForm.action =url; 
		 myForm.method="post";
		 myForm.target="form";
		 myForm.submit();

			
	}
</script>
<body align="center">
	<h1>reservation 페이지</h1>
	<h1>${sessionScope.loginID }</h1>
	<table align="center">
		<tr>
			<td colspan=2>예약 정보</td>
		</tr>
		<tr>
			<td colspan=2><input type="text" id="parkingName"
				name="parkingName" value="${booking.parking.prkplcenm }"
				readonly="readonly"></td>
		</tr>

		<tr>
			<td colspan=2><input type="text" id="reserveCharge"
				name="reserveCharge" readonly="readonly" value="${booking.price }"></td>
		</tr>

		<tr>
			<td><input type="text" id="pointBalance" name="pointBalance"
				readonly="readonly"></td>
			<td><input type="button" value="포인트 잔액 확인"
				onclick="pointCheck()"></td>
		</tr>
	</table>

	<hr style="border: 1">
	<div class="pointUse" style="display: none">
		<input type="button" value="결제하기" onclick="payUse()">
		<input	type="button" value="포인트 사용하기" onclick="pointUse()">

	</div>

	<div class="payUse" style="display: none">
		<input type="button" value="결제하기" onclick="payUse()"> 
		<input	type="button" value="포인트 충전하기"	onclick="pointCharge()">

	</div>

</body>
</html>