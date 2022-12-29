// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.15;

import "../../src/Watcher/WatcherFactory.sol";
import "./FoundrySuperfluidTester.sol";

abstract contract Setup is FoundrySuperfluidTester {
    using CFAv1Library for CFAv1Library.InitData;

    WatcherFactory Factory;
    address watcherImplementation;

    address constant deployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    constructor() FoundrySuperfluidTester(3) {}

    function setUp() public override {
        // Deploy new stream manager implementation contract.
        watcherImplementation = address(new Watcher());

        // Deploy factory contract.
        Factory = new WatcherFactory({
            _cfaV1Forwarder: address(sf.cfaV1Forwarder),
            _watcherImplementation: watcherImplementation
        });

        // Creates a mock token and a supertoken and fills the mock wallets.
        FoundrySuperfluidTester.setUp();

        // Filling the deployer's wallet with mock tokens and supertokens.
        fillWallet(deployer);
    }

    function _createWatcher()
        internal
        returns (
            address _newWatcher
        )
    {
        vm.startPrank(admin);

        // Initialising a creator set.
        _newWatcher = Factory.initWatcher(
            "TESTING",
            "TEST",
            address(superToken),
            _convertToRate(1e10)
        );

        vm.stopPrank();
    }

    function _convertToRate(uint256 _rate)
        internal
        pure
        returns (int96 _flowRate)
    {
        _flowRate = int96(int256(_rate / 2592000));
    }
}