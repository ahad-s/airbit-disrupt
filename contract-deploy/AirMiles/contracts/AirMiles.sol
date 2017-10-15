pragma solidity ^0.4.11;

import './MintableToken.sol';
import './StandardToken.sol';
import './oraclizeAPI_0.4.sol';

contract AirMiles is MintableToken, usingOraclize  {

  string public name = "AirMiles";
  string public symbol = "AM";
  uint8 public constant decimals = 0;
  uint256 public constant INITIAL_SUPPLY = 0;

	struct MileageAccount  {
 		string airline;
		string account;
		string pwd;	
		bool verified;
	}
	struct Miles {
	    address user;
	    uint256 miles;
	}
	struct OraclizeResponse {
	    address user;
	    string airline;
	}
    // event newOraclizeQuery(string description);
	mapping (address => MileageAccount[]) UserAccounts;
	// FIXME - move this off the chain
	mapping (string => Miles[]) AirlinesToMiles;
// 	mapping (bytes32 => OraclizeResponse) oraclizeTracker;

	
	function AirMiles() payable {
	    totalSupply = 0;
	    balances[msg.sender] = 0;
	}

	function register(address user) public {
		UserAccounts[user].push(MileageAccount("", "","", false));
	}
	
/*	function __callback(bytes32 id, string result) {
		uint256 miles =  parseInt(result);
		AirlinesToMiles[oraclizeTracker[id].airline].push(Miles(oraclizeTracker[id].user, miles));
		totalSupply += miles;
		balances[oraclizeTracker[id].user] += miles;
	}

    function callOraclize(string airline, string acct, address user) payable public {
		string memory url = strConcat("json(http://aircoin-disrupt.herokuapp.com/getBalanceFromAirline?airline=", airline, "&username=", acct, ").result.miles"); 
		// Make oraclize call to verify the miles
		if (oraclize_getPrice("URL") <= this.balance) {
			newOraclizeQuery("Oraclize Add some ETH to cover for the query fee");
		} else {
			newOraclizeQuery("Sending GET query... waiting for answer");
			bytes32 id = oraclize_query("URL", url);
			oraclizeTracker[id] = OraclizeResponse(user, airline);
		}
    }
*/
	// TODO: require user exists
	function addMiles(address user, string airline, string account, string pwd, uint32 miles) payable public {
 		UserAccounts[user].push(MileageAccount(airline, account, pwd, false));
// 		callOraclize(airline, account, user);
		AirlinesToMiles[airline].push(Miles(user, miles));
		totalSupply += miles;
		balances[user] += miles;
	}
	
	function updateMiles(string airline, address _from, address _to, uint32 miles) {
	    Miles[] all = AirlinesToMiles[airline];
        for (uint i = 0; i < all.length; i++) {
            if (_from == all[i].user)
                all[i].miles -= miles;
            if (_to == all[i].user)
                all[i].miles += miles;
        }
	}
	
	// TODO: require queryingUser exists
	function findMiles(address queryingUser, string airline, uint32 needed) public returns (bool) {
	   Miles[] allMiles = AirlinesToMiles[airline];
	    for (uint i = 0; i < allMiles.length; i++) {
	        Miles m = AirlinesToMiles[airline][i];
	        if ((queryingUser != m.user) && (m.miles >= needed)) {
	           updateMiles(airline, m.user, queryingUser, needed);
	           balances[m.user] -= needed;
	           balances[queryingUser] += needed;
	           // transferFrom(m.user, queryingUser, needed);
	           return true;
            }
	    }
	    return false;
	}
    function showMiles(string airline, address user) returns (uint256) {
        Miles[] all = AirlinesToMiles[airline];
        for (uint i = 0; i < all.length; i++) {
            if (user == all[i].user)
                return all[i].miles;
        }        
    }
}