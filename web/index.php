<?php
include '/config/web/inc.php';
?>

<?php
$mysqli = new mysqli("$sqlhost", "$sqluser", "$sqlpwd", "$sqldb");
if (mysqli_connect_errno()){
    echo '<p><a href="./rutorrent/">PT下载工具</a></p>';
    $mysqli=null;
    exit;
}
$query="SELECT * FROM members WHERE username=$username";
$result=$mysqli->query($query);
$row = $result->fetch_array();
$price=$row['price'];
$expire_time=$row['expire_time'];
$email=$row['email'];
$result->free();
$mysqli->close();

?>



<!DOCTYPE html>
<html lang="en_US">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LazyPT-雷击霹雳</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
<link href="./css" rel="stylesheet" type="text/css">
<link href="./style.css" rel="stylesheet" type="text/css">
</head>

<body>
<header>
<h1>LazyPT</h1>
<p><a href="http://www.lazypt.net/">lazypt.net</a>-雷击霹雳</p>
</header>

<main>
<section>
<img src="./utorrent.png">
<div>
<h2>RuTorrent</h2>
    <p>SeedBox IP: <?php echo $email; ?></p>
  <?php
    if (($expire_time-time())>0){$remain_time=round(($expire_time-time())/86400,2);}
    else {$remain_time=0;}
    echo "剩余时间：".$remain_time."天";
    echo "<br />";
    if (($expire_time-time())<604800) {echo '<font color="red">请及时续费！到期后盒子将被自动回收并清除数据！</font>';}
  ?>
    <p><a href="./rutorrent/">PT下载工具</a></p>
    <p><a href="http://my.lazypt.net/" target="_blank">修改密码</a></p>
    <p>注意事项：</p>
    <p>1.盒子在校验文件时可能出现连接困难，请稍后重试；</p>
    <p>2.请勿一次添加过多新种，建议一次添加5个种子；</p>
    <p>3.请确保有足够的磁盘空间，建议留有5%的空间。</p>
</div>
</section>

<section>
<img src="./explorer.png">
<div>
<h2>File explorer</h2>
<p><a href="./downloads/">浏览文件</a></p>
</div>
</section>

<section>
<img src="./recharge.png">
<div>
<h2>Recharge</h2>

<?php
    if (($expire_time-time())>0){$exp_date=date("Y-m-d H:i:s",$expire_time);}
    else {$exp_date="过期";}
  echo "到期日: ".$exp_date;
  echo "<br />";
?>

<form action="http://www.lazypt.net/pay/shanpay.php" method="post" target="_blank">
<input type="hidden" name="WIDout_trade_no" value="RE<?PHP echo time().mt_rand(10000000000,99999999999).$username ?>"/>
<input type="hidden" name="WIDsubject" value="seedbox"/>
<input type="hidden" name="WIDtotal_fee" value="<?PHP echo $price;?>"/>
<input type="hidden" name="WIDbody" value="seedbox"/>
<button type="submit" value="Submit">续费30天</button>
</form>
<p>请在电脑端续费</p>

</div>
</section>
</main>

<footer>
<p>©2016 - 2017 <br> <a href="http://www.lazypt.net/">雷击霹雳</a>|交流QQ群：548856096</p>
</footer>
</body>
</html>
