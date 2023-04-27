// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import "../interfaces/IVammModule.sol";
import "../storage/DatedIrsVamm.sol";
import "@voltz-protocol/util-contracts/src/storage/OwnableStorage.sol";

/**
 * @title Module for configuring a market
 * @dev See IMarketConfigurationModule.
 */
contract VammModule is IVammModule {
    using DatedIrsVamm for DatedIrsVamm.Data;

    /**
     * @inheritdoc IVammModule
     */
    function createVamm(uint128 _marketId,  uint160 _sqrtPriceX96, VammConfiguration.Immutable calldata _config, VammConfiguration.Mutable calldata _mutableConfig)
    external override
    {
        OwnableStorage.onlyOwner();
        DatedIrsVamm.Data storage vamm = DatedIrsVamm.create(_marketId, _sqrtPriceX96, _config, _mutableConfig);
        emit VammCreated(
            _marketId,
            vamm.vars.tick,
            _config,
            _mutableConfig
        );
    }

    /**
     * @inheritdoc IVammModule
     */
    function configureVamm(uint128 _marketId, uint256 _maturityTimestamp, VammConfiguration.Mutable calldata _config)
    external override
    {
        OwnableStorage.onlyOwner();
        DatedIrsVamm.Data storage vamm = DatedIrsVamm.loadByMaturityAndMarket(_marketId, _maturityTimestamp);
        vamm.configure(_config);
        emit VammConfigUpdated(_marketId, _config);
    }

    /**
     * @inheritdoc IVammModule
     */
    function getAdjustedDatedIRSGwap(uint128 marketId, uint32 maturityTimestamp, int256 orderSize, uint32 lookbackWindow) 
        external view override returns (UD60x18 datedIRSGwap) 
    {
        DatedIrsVamm.Data storage vamm = DatedIrsVamm.loadByMaturityAndMarket(marketId, maturityTimestamp);
        datedIRSGwap = vamm.twap(lookbackWindow, orderSize, true, true);
    }

    /**
     * @inheritdoc IVammModule
     */
    function getDatedIRSGwap(uint128 marketId, uint32 maturityTimestamp, uint32 lookbackWindow, int256 orderSize, bool adjustForPriceImpact,  bool adjustForSpread) 
        external view override returns (UD60x18 datedIRSGwap) 
    {
        DatedIrsVamm.Data storage vamm = DatedIrsVamm.loadByMaturityAndMarket(marketId, maturityTimestamp);
        datedIRSGwap = vamm.twap(lookbackWindow, orderSize, adjustForPriceImpact, adjustForSpread);
    }
}
