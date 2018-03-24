<?php

require 'JSON.php';

if (!isset($_GET['groupid']))
    die;

$groupId = $_GET['groupid'];
    
$filters = array(
    1 => "12,AVGVALUE|29,AVGVALUE|111,AVGVALUE",
    2 => "9,AVGVALUE|10,AVGVALUE|11,AVGVALUE|12,AVGVALUE",
    3 => "35,AVGVALUE|34,AVGVALUE|32,AVGVALUE|33,AVGVALUE",
    4 => "62,AVGVALUE|79,AVGVALUE|112,AVGVALUE",
    5 => "59,AVGVALUE|60,AVGVALUE|61,AVGVALUE|62,AVGVALUE",
    6 => "85,AVGVALUE|84,AVGVALUE|82,AVGVALUE|83,AVGVALUE",
    7 => "35,AVGVALUE|85,AVGVALUE"
);
    
$filter = $filters[$groupId];
    
$period = (integer)$_GET['period'];
    
$now = time();
    
$dateOut = mktime();
$dateIn = mktime(date("H") - $period, date("i"), date("s"), date("n"), date("j"), date("Y"));
$dateOutStr = strftime("%Y-%m-%d %H:%M:%S.000", $dateOut);
$dateInStr = strftime("%Y-%m-%d %H:%M:%S.000", $dateIn);
    
header("Content-Type: text/plain");

$serverName = "159.93.126.225,1433\MACSRV";
$login = "sa";
$pwd = "sa80@sql";
$dbname = "macweb";
    
$conn = mssql_connect($serverName, $login, $pwd);
    
if (!$conn)
{
    $msg = mssql_get_last_message();
    // echo " ";      
    exit(" ");
}
    
if (!mssql_select_db($dbname))
{
    $msg = mssql_get_last_message();        
    // echo " ";
    exit(" ");
    // die($msg);
}
    
$query = "exec S_VarCache @Method='GET', @datein={ts '$dateInStr'}, 
                                         @dateout={ts '$dateOutStr'},
                                         @sObjId='$filter'";

$stmt = mssql_query($query);
    
if ($stmt == false)
{
    $msg = mssql_get_last_message();        
    // echo " ";   
    exit(" "); 
    // die($msg);
}
//echo "query";    
if (($row = mssql_fetch_assoc($stmt)) && (isset($row['ResultTxt'])))
{
    $result = " ";
//    $res = array();
    $json = json_decode($row['ResultTxt']);
     $res = array();
    
    $count = count($json);
//echo "before for:";
    for ($i = 0; $i < $count; $i++)
    {
        $obj = $json[$i];
        $date = explode(" ", $obj->TS[0]);
        $time = explode(".", $date[1]);
        $x = $time[0];
        $s = "";
        $res[][] = $obj->TS[0]; 
        $variables = array();
//        echo $i . " ". $obj->TS[0] . " " . " \n" ;

        $startIndex = 0;
        $objIdCount = count($obj->ID);
 //       echo  "count="+$objIdCount+" ";
        for ($j = 0; $j < $objIdCount; $j++)
        {
            $vc = $obj->VC[$j];
            for ($k = $startIndex; $k < $startIndex + $vc; $k++)
            {
                $key = $obj->ID[$j] . "," . $obj->VN[$k];
                $val = round((float)str_replace(",", ".", $obj->VV[$k]), 3);
                $variables[$key] = $val;
//                echo $key." === ".$val."/";
            }
            $startIndex += $vc;
        }

        $result .= $x;
        $filtersArray = explode("|", $filter);
        
        if (($groupId == 2) || ($groupId == 5))
        {
            $y3 = $variables[$filtersArray[0]];
            $y4 = $variables[$filtersArray[1]];
            $y5 = $variables[$filtersArray[2]];
            $y6 = $variables[$filtersArray[3]];

            if (isset($y6)) {
                $result .= ";" . $y6;
                $res[$i][] = $y6;
            }
            else {
                $result .= ";0";
                $res[$i][] = 0;
            }


            if ((isset($y5)) && (isset($y6))){
                $result .= ";" . ($y5 - $y6);
                $res[$i][] = $y5-$y6;
            }
            else{
                $result .= ";0";
                $res[$i][] = 0;
            }

            if ((isset($y3)) && (isset($y4))){
                $result .= ";" . ($y3 - $y4);
                $res[$i][] = $y3 - $y4;
            }
            else{
                $result .= ";0";
                $res[$i][] = 0;
            }
            $result .= "\n";
        }
        else
        {
            for ($k = 0; $k < count($filtersArray); $k++)
            {
                $var = $variables[$filtersArray[$k]];
                if (isset($var)){
                    $result .= ";" . $var;
                    $res[$i][] = $var;
                }
                else{
                    $result .= ";0";
                    $res[$i][] = 0;
                }
            }
            $result .= "\n";
        }
    }
   
//    echo $json;
    $callback = $_GET['callback'];
//    echo JSON::enclose($callback, $json);
    $json = json_encode($res);
    echo JSON::enclose($callback, $json);

}
    
mssql_close($conn);
?>