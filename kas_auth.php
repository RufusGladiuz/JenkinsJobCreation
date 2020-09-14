<?php

$ids=array(
	'kas_login' => $argv[1],          // das KAS-Login
	'kas_auth_type' => 'plain',
	'kas_auth_data' => $argv[2],// das KAS-Passwort
	'kas_action' => 'get_dns_settings',
    'session_lifetime' => 600,         // Gültigkeit des Tokens in Sekunden
	'session_update_lifetime' => 'Y',
	'KasRequestParams' => array(
		'zone_host' => $argv[3]
   	) //domain   // Y|N: bei Y verlängert sich die Session mit jedem Request
);

$mainId=0;
$wildCardId=0;

try {
	//global $CredentialToken,$mainId,$wildCardId;
	$SoapLogon = new SoapClient('http://kasapi.kasserver.com/soap/wsdl/KasApi.wsdl');
	$response = $SoapLogon->KasApi(json_encode($ids));
	$mainId= $response["Response"]["ReturnInfo"][0]["record_id"];
	$wildCardId= $response["Response"]["ReturnInfo"][1]["record_id"];
}

// Fehler abfangen und ausgeben
catch (SoapFault $fault) {
	trigger_error("Fehlernummer: {$fault->faultcode},
					Fehlermeldung: {$fault->faultstring},
					Verursacher: {$fault->faultactor},
					Details: {$fault->detail}", E_USER_ERROR);
}


$Params=array(
	'kas_login' => $argv[1],          // das KAS-Login
	'kas_auth_type' => 'plain',
	'kas_auth_data' => $argv[2],// das KAS-Passwort
    'kas_action' => 'update_dns_settings',
	'record_type' => 'A',
	'KasRequestParams' => array(
		'record_id' => $mainId,
		'record_data' => $argv[4],
		'zone_host' => $argv[3]
	), //IP address
    'session_lifetime' => 600,         // Gültigkeit des Tokens in Sekunden
	'session_update_lifetime' => 'Y'   // Y|N: bei Y verlängert sich die Session mit jedem Request
);

try {
	$SoapLogon = new SoapClient('http://kasapi.kasserver.com/soap/wsdl/KasApi.wsdl');
	$response = $SoapLogon->KasApi(json_encode($Params));
}

// Fehler abfangen und ausgeben
catch (SoapFault $fault) {
	trigger_error("Fehlernummer: {$fault->faultcode},
					Fehlermeldung: {$fault->faultstring},
					Verursacher: {$fault->faultactor},
					Details: {$fault->detail}", E_USER_ERROR);
}

sleep(10);

$ParamsWild=array(
	'kas_login' => $argv[1],          // das KAS-Login
	'kas_auth_type' => 'plain',
	'kas_auth_data' => $argv[2],// das KAS-Passwort
    'kas_action' => 'update_dns_settings',
	'record_type' => 'A',
	'KasRequestParams' => array(
		'record_id' => $wildCardId,
		'record_data' => $argv[4],
		'zone_host' => $argv[3]
	), //IP address
    'session_lifetime' => 600,         // Gültigkeit des Tokens in Sekunden
	'session_update_lifetime' => 'Y'   // Y|N: bei Y verlängert sich die Session mit jedem Request
);

try {
	$SoapLogon = new SoapClient('http://kasapi.kasserver.com/soap/wsdl/KasApi.wsdl');
	$response = $SoapLogon->KasApi(json_encode($ParamsWild));
}

// Fehler abfangen und ausgeben
catch (SoapFault $fault) {
	trigger_error("Fehlernummer: {$fault->faultcode},
					Fehlermeldung: {$fault->faultstring},
					Verursacher: {$fault->faultactor},
					Details: {$fault->detail}", E_USER_ERROR);
}

?>