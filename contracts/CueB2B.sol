// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@tableland/evm/contracts/ITablelandTables.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "usingtellor/contracts/UsingTellor.sol";

contract CueB2B is ERC721Holder, Ownable, UsingTellor {
    ITablelandTables internal _tableland;
    string internal _tablePrefix;
    uint256 internal _tableId;
    uint256 internal _counter;
    mapping(string => uint256) public tables;
    mapping(address => string) public walletToCompany;
    string apiUrl = "https://cue-tellor.vercel.app/query/";
    string parseArgs = "message";
    string permissionTable;
    string notifTable;
    string registerTable;

    constructor(address _registry, address payable _tellorAddress)
        payable
        UsingTellor(_tellorAddress)
    {
        _tableland = ITablelandTables(_registry);
        _counter = 0;
    }

    event Notify(string indexed wallet_address, string indexed notif_id);

    function create(string memory prefix, string memory tableStatement)
        public
        payable
        onlyOwner
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

    /**
     * @notice create an org or a company
     */
    function register(string memory company) public {
        walletToCompany[msg.sender] = company;
    }

    /**
     * @notice set or change the API Url used by Tellor Oracle
     */
    function setNewApiUrl(string memory newApiUrl) public onlyOwner {
        apiUrl = newApiUrl;
    }

    /**
     * @notice set the name of the table used to store the apps allowed by user to send them notifs
     */
    function setPermissionTable(string memory tableName) public onlyOwner {
        permissionTable = tableName;
    }

    /**
     * @notice set the name of the table used to store the notifs sent by apps
     */

    function setNotifTable(string memory tableName) public onlyOwner {
        notifTable = tableName;
    }

    /**
     * @notice set the name of the table used to store the apps' contract addresses
     */

    function setRegisterTable(string memory tableName) public onlyOwner {
        registerTable = tableName;
    }

    /**
     * @notice add a new entry to notification table
     */

    function writeToNotifTable(
        string memory company_name,
        string memory notif_name,
        string memory ipfs_hash
    ) external payable {
        require(
            keccak256(abi.encodePacked(walletToCompany[msg.sender])) == //check if the sender has registered a company
                keccak256(abi.encodePacked(company_name))
        );
        _tableland.runSQL(
            address(this),
            tables[notifTable],
            string.concat(
                "INSERT INTO ",
                notifTable,
                " (id, company_name, notif_name, ipfs_hash) VALUES (",
                StringsUpgradeable.toString(_counter),
                ", '",
                company_name,
                ", '",
                notif_name,
                "', '",
                ipfs_hash,
                "');"
            )
        );
        _counter = _counter + 1;
    }

    /**
     * @notice add a new entry to contract regostration table
     */

    function writeToContractRegisterTable(
        string memory company_name,
        address contract_address
    ) external payable {
        require(
            keccak256(abi.encodePacked(walletToCompany[msg.sender])) == //check if the sender has registered a company
                keccak256(abi.encodePacked(company_name))
        );
        string memory contract_Address = StringsUpgradeable.toString(
            uint160(contract_address)
        );
        _tableland.runSQL(
            address(this),
            tables[registerTable],
            string.concat(
                "INSERT INTO ",
                registerTable,
                " (id, company_name, contract_address) VALUES (",
                StringsUpgradeable.toString(_counter),
                ", '",
                company_name,
                ", '",
                contract_Address,
                "');"
            )
        );
        _counter = _counter + 1;
    }

    function checkUserPermission(
        string memory company_name,
        string memory wallet_address
    ) internal view returns (bool) {
        string memory queryUrl = string.concat(
            apiUrl,
            "/queryUser/",
            permissionTable,
            "/",
            company_name,
            "/",
            wallet_address
        );
        bytes memory queryData = abi.encode(
            "NumericApiResponse",
            abi.encode(queryUrl, parseArgs)
        );

        bytes32 queryId = keccak256(queryData);

        (, bytes memory value, ) = getCurrentValue(queryId);

        uint256 permissionBigInt = abi.decode(value, (uint256));

        uint256 permission = permissionBigInt / 1000000000000000000;

        if (permission == 1) {
            return true;
        } else {
            return false;
        }
    }

    function checkContractRegistration(
        string memory company_name,
        string memory contract_address
    ) internal view returns (bool) {
        string memory queryUrl = string.concat(
            apiUrl,
            "/queryContract/",
            registerTable,
            "/",
            company_name,
            "/",
            contract_address
        );
        bytes memory queryData = abi.encode(
            "NumericApiResponse",
            abi.encode(queryUrl, parseArgs)
        );

        bytes32 queryId = keccak256(queryData);

        (, bytes memory value, ) = getCurrentValue(queryId);

        uint256 contractRegBigInt = abi.decode(value, (uint256));

        uint256 contractReg = contractRegBigInt / 1000000000000000000;

        if (contractReg == 1) {
            return true;
        } else {
            return false;
        }
    }

    function sendNotif(
        string memory company_name,
        string memory wallet_address,
        string memory notif_name
    ) external payable {
        require(
            checkUserPermission(company_name, wallet_address),
            "User has not set permission to send notif"
        );
        require(
            checkContractRegistration(
                company_name,
                StringsUpgradeable.toString(uint160(msg.sender))
            ),
            "Contract not registered"
        );

        emit Notify(wallet_address, notif_name);
    }
}
