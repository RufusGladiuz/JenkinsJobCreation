<?php

$Params=array(
	'kas_login' => '662513',          // das KAS-Login
	'kas_auth_type' => 'sha1',
	'kas_auth_data' => sha1('Yallagang91'),// das KAS-Passwort
    'kas_action' => 'add_dns_settings',
    'record_name' => 'test'
    'record_type' => 'A',
    'record_data' => $argv[1],
    'record_aux' => 0,
    'zone_host' => $argv[2]
    'session_lifetime' => 600,         // Gültigkeit des Tokens in Sekunden
	'session_update_lifetime' => 'Y',   // Y|N: bei Y verlängert sich die Session mit jedem Request
	'session_2fa' => 123456            // optional: falls aktiviertm die One-Time-Pin für die 2FA
);

try {
	$SoapLogon = new SoapClient('https://kasapi.kasserver.com/soap/wsdl/KasAuth.wsdl');
	$CredentialToken = $SoapLogon->KasAuth(json_encode($Params));
	echo "Ihr SessionToken lautet: $CredentialToken"; //  bd6d56c7a992c53e521410ef067e13dc
}

// Fehler abfangen und ausgeben
catch (SoapFault $fault) {
	trigger_error("Fehlernummer: {$fault->faultcode},
					Fehlermeldung: {$fault->faultstring},
					Verursacher: {$fault->faultactor},
					Details: {$fault->detail}", E_USER_ERROR);
}

?>