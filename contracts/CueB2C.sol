// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@tableland/evm/contracts/ITablelandTables.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CueB2C is ERC721Holder, Ownable {
    ITablelandTables internal _tableland;
    string internal _tablePrefix;
    string public tableName;
    uint256 internal _tableId;
    uint256 internal _counter;

    constructor(address _registry) payable {
        _tablePrefix = "cue_ethereum";
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
                " (id int primary key, protocol text, wallet_address text, token text, deposit_withdraw text, notify_by text, posted_by text);"
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

    function writeTotable(
        string memory protocol,
        string memory wallet_address,
        string memory token,
        string memory deposit_withdraw,
        string memory notify_by
    ) external payable {
        string memory posted_by = StringsUpgradeable.toString(
            uint160(msg.sender)
        );
        _tableland.runSQL(
            address(this),
            _tableId,
            string.concat(
                "INSERT INTO ",
                tableName,
                " (id, protocol, wallet_address, token, deposit_withdraw, notify_by, posted_by) VALUES (",
                StringsUpgradeable.toString(_counter),
                ", '",
                protocol,
                "', '",
                wallet_address,
                "', '",
                token,
                "', '",
                deposit_withdraw,
                "', '",
                notify_by,
                "', '",
                posted_by,
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
