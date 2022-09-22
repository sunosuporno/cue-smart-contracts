// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "./ICueB2B.sol";

contract TestContract {
    ICueB2B internal _cueB2B;

    constructor(address _registry) payable {
        _cueB2B = ICueB2B(_registry);
    }

    function testNotifs(string memory company_name, string memory notif_name)
        external
        payable
    {
        string memory wallet_address = StringsUpgradeable.toString(
            uint160(msg.sender)
        );
        _cueB2B.sendNotif(company_name, wallet_address, notif_name);
    }
}
