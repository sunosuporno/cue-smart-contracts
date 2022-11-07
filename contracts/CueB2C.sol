// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@tableland/evm/contracts/ITablelandTables.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract CueB2C is Initializable, ERC721HolderUpgradeable, OwnableUpgradeable {
    ITablelandTables internal _tableland;
    string internal _tablePrefix;
    uint256 internal _tableId;
    uint256 internal _counter;
    mapping(string => uint256) public tables;
    string public token_transact_table;
    string public nft_floor_table;
    string public token_price_table;
    string public snapshot_table;

    function initialize(address _registry) public payable initializer {
        __ERC721Holder_init();
        __Ownable_init();
        _tableland = ITablelandTables(_registry);
        _counter = 0;
    }

    function create(string memory prefix, string memory tableStatement)
        external
        payable
    {
        uint256 tableId = _tableland.createTable(
            address(this),
            string.concat(
                "CREATE TABLE ",
                prefix,
                "_",
                StringsUpgradeable.toString(block.chainid),
                " (",
                tableStatement,
                ");"
            )
        );

        string memory tableName = string.concat(
            prefix,
            "_",
            StringsUpgradeable.toString(block.chainid),
            "_",
            StringsUpgradeable.toString(tableId)
        );

        tables[tableName] = tableId;
    }

    function setTokenTransactTable(string memory tableName) external onlyOwner {
        token_transact_table = tableName;
    }

    function setNFTFloorTable(string memory tableName) external onlyOwner {
        nft_floor_table = tableName;
    }

    function setTokenPriceTable(string memory tableName) external onlyOwner {
        token_price_table = tableName;
    }

    function setSnapshotTable(string memory tableName) public onlyOwner {
        snapshot_table = tableName;
    }

    function writeToTokenTransactTable(
        string memory protocol,
        string memory wallet_address,
        string memory token,
        string memory deposit_withdraw,
        string memory notify_by
    ) external payable {
        _tableland.runSQL(
            address(this),
            tables[token_transact_table],
            string.concat(
                "INSERT INTO ",
                token_transact_table,
                " (protocol, wallet_address, token, deposit_withdraw, notify_by, posted_by) VALUES ('",
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
                StringsUpgradeable.toHexString(_msgSender()),
                "');"
            )
        );
        _counter = _counter + 1;
    }

    function writeToNFTFloorTable(
        string memory collection_address,
        uint256 floor_price,
        string memory notify_by
    ) external payable {
        _tableland.runSQL(
            address(this),
            tables[nft_floor_table],
            string.concat(
                "INSERT INTO ",
                nft_floor_table,
                " (collection_address, floor_price, notify_by, posted_by) VALUES ('",
                collection_address,
                "', '",
                StringsUpgradeable.toString(floor_price),
                "', '",
                notify_by,
                "', '",
                StringsUpgradeable.toHexString(_msgSender()),
                "');"
            )
        );
        _counter = _counter + 1;
    }

    function writeToTokenPriceTable(
        string memory token_address,
        uint256 price,
        string memory g_or_l,
        string memory notify_by
    ) external payable {
        _tableland.runSQL(
            address(this),
            tables[token_price_table],
            string.concat(
                "INSERT INTO ",
                token_price_table,
                " (token_address, price, g_or_l, notify_by, posted_by) VALUES ('",
                token_address,
                "', '",
                StringsUpgradeable.toString(price),
                "', '",
                g_or_l,
                "', '",
                notify_by,
                "', '",
                StringsUpgradeable.toHexString(_msgSender()),
                "');"
            )
        );
        _counter = _counter + 1;
    }

    function writeToSnapshotTable(
        string memory space,
        string memory action,
        string memory notify_by
    ) external payable {
        _tableland.runSQL(
            address(this),
            tables[snapshot_table],
            string.concat(
                "INSERT INTO ",
                snapshot_table,
                " (space, action, notify_by, posted_by) VALUES ('",
                space,
                "', '",
                action,
                "', '",
                notify_by,
                "', '",
                StringsUpgradeable.toHexString(_msgSender()),
                "');"
            )
        );
        _counter = _counter + 1;
    }

    function deleteFromTokenTransactTable(uint256 id) external payable {
        _tableland.runSQL(
            address(this),
            tables[token_transact_table],
            string.concat(
                "DELETE FROM ",
                token_transact_table,
                " WHERE id = ",
                StringsUpgradeable.toString(id)
            )
        );
    }

    function deleteFromNFTFloorTable(uint256 id) external payable {
        _tableland.runSQL(
            address(this),
            tables[nft_floor_table],
            string.concat(
                "DELETE FROM ",
                nft_floor_table,
                " WHERE id = ",
                StringsUpgradeable.toString(id)
            )
        );
    }

    function deleteFromTokenPriceTable(uint256 id) external payable {
        _tableland.runSQL(
            address(this),
            tables[token_price_table],
            string.concat(
                "DELETE FROM ",
                token_price_table,
                " WHERE id = ",
                StringsUpgradeable.toString(id)
            )
        );
    }

    function deleteFromSnapshotTable(uint256 id) external payable {
        _tableland.runSQL(
            address(this),
            tables[snapshot_table],
            string.concat(
                "DELETE FROM ",
                snapshot_table,
                " WHERE id = ",
                StringsUpgradeable.toString(id)
            )
        );
    }
}
