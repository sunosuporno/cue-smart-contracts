// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@tableland/evm/contracts/ITablelandTables.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NotifAllowList is ERC721Holder, Ownable {
    ITablelandTables internal _tableland;
    string internal _tablePrefix;
    string public tableName;
    uint256 internal _tableId;
    uint256 internal _counter;

    constructor(address _registry) payable {
        _tablePrefix = "notifs_allowlist";
        _tableland = ITablelandTables(_registry);
        _counter = 0;
    }

    function createTable() external payable onlyOwner {
        _tableId = _tableland.createTable(
            address(this),
            string.concat(
                "CREATE TABLE ",
                _tablePrefix,
                "_",
                StringsUpgradeable.toString(block.chainid),
                " (id int primary key, wallet_address text, company_name text);"
            )
        );

        tableName = string.concat(
            _tablePrefix,
            "_",
            StringsUpgradeable.toString(block.chainid),
            "_",
            StringsUpgradeable.toString(_tableId)
        );
    }

    function writeTotable(string memory company_name) external payable {
        string memory wallet_address = StringsUpgradeable.toString(
            uint160(msg.sender)
        );
        _tableland.runSQL(
            address(this),
            _tableId,
            string.concat(
                "INSERT INTO ",
                tableName,
                " (id, wallet_address, company_name) VALUES (",
                StringsUpgradeable.toString(_counter),
                ", '",
                wallet_address,
                "', '",
                company_name,
                "');"
            )
        );
        _counter = _counter + 1;
    }

    function deleteFromTable(uint256 id) external payable {
        _tableland.runSQL(
            address(this),
            _tableId,
            string.concat(
                "DELETE FROM ",
                tableName,
                " WHERE id = ",
                StringsUpgradeable.toString(id)
            )
        );
    }
}
