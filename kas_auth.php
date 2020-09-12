<?php

$ids=array(
	'kas_login' => $argv[1],          // das KAS-Login
	'kas_auth_type' => 'plain',
	'kas_auth_data' => $argv[2],// das KAS-Passwort
	'kas_action' => 'get_dns_settings',
    'session_lifetime' => 600,         // Gültigkeit des Tokens in Sekunden
	'session_update_lifetime' => 'Y',
	'zone_host' =>  'onur-rouven.de', //domain   // Y|N: bei Y verlängert sich die Session mit jedem Request
);

$mainId=0;
$wildCardId=0;

try {
	//global $CredentialToken,$mainId,$wildCardId;
	$SoapLogon = new SoapClient('http://kasapi.kasserver.com/soap/wsdl/KasApi.wsdl');
	$response = $SoapLogon->KasApi(json_encode($ids));
	//$mainId= $recordIds[0]["record_id"];
	//$wildCardId= $recordIds[1]["record_id"];
	print_r($response);
}

// Fehler abfangen und ausgeben
catch (SoapFault $fault) {
	trigger_error("Fehlernummer: {$fault->faultcode},
					Fehlermeldung: {$fault->faultstring},
					Verursacher: {$fault->faultactor},
					Details: {$fault->detail}", E_USER_ERROR);
}


// $Params=array(
// 	'kas_login' => $argv[1],          // das KAS-Login
// 	'kas_auth_type' => 'plain',
// 	'kas_auth_data' => $argv[2],// das KAS-Passwort
//     'kas_action' => 'update_dns_settings',
// 	'record_type' => 'A',
// 	'record_id' => $mainId,
//     'record_data' => $argv[4], //IP address
//     'session_lifetime' => 600,         // Gültigkeit des Tokens in Sekunden
// 	'session_update_lifetime' => 'Y'   // Y|N: bei Y verlängert sich die Session mit jedem Request
// 	//'session_2fa' => 123456            // optional: falls aktiviertm die One-Time-Pin für die 2FA
// );

// try {
// 	$SoapLogon = new SoapClient('http://kasapi.kasserver.com/soap/wsdl/KasAuth.wsdl');
// 	$CredentialToken = $SoapLogon->KasAuth(json_encode($Params));
// 	echo "Ihr SessionToken lautet: $CredentialToken"; //  bd6d56c7a992c53e521410ef067e13dc
// }

// // Fehler abfangen und ausgeben
// catch (SoapFault $fault) {
// 	trigger_error("Fehlernummer: {$fault->faultcode},
// 					Fehlermeldung: {$fault->faultstring},
// 					Verursacher: {$fault->faultactor},
// 					Details: {$fault->detail}", E_USER_ERROR);
// }

// $ParamsWildCard=array(
// 	'kas_login' => $argv[1],          // das KAS-Login
// 	'kas_auth_type' => 'plain',
// 	'kas_auth_data' => $argv[2],// das KAS-Passwort
// 	'kas_action' => 'update_dns_settings',
// 	'record_name' => '*',
// 	'record_type' => 'A',
// 	'record_id' => $wildCardId,
//     'record_data' => $argv[4], //IP address
//     'session_lifetime' => 600,         // Gültigkeit des Tokens in Sekunden
// 	'session_update_lifetime' => 'Y'   // Y|N: bei Y verlängert sich die Session mit jedem Request
// 	//'session_2fa' => 123456            // optional: falls aktiviertm die One-Time-Pin für die 2FA
// );

// try {
// 	$SoapLogon = new SoapClient('http://kasapi.kasserver.com/soap/wsdl/KasAuth.wsdl');
// 	$CredentialToken = $SoapLogon->KasAuth(json_encode($ParamsWildCard));
// 	echo "Ihr SessionToken lautet: $CredentialToken"; //  bd6d56c7a992c53e521410ef067e13dc
// }

// // Fehler abfangen und ausgeben
// catch (SoapFault $fault) {
// 	trigger_error("Fehlernummer: {$fault->faultcode},
// 					Fehlermeldung: {$fault->faultstring},
// 					Verursacher: {$fault->faultactor},
// 					Details: {$fault->detail}", E_USER_ERROR);
// }

?>