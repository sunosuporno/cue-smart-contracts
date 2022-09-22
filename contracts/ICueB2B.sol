// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface ICueB2B {
    error Unauthorized();

    event Notify(string indexed wallet_address, string indexed notif_id);

    function sendNotif(
        string memory company_name,
        string memory wallet_address,
        string memory notif_name
    ) external payable;
}
