# Copyright (C) 2021 VolumeFi Software, Inc.

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the Apache 2.0 License. 
#  This program is distributed WITHOUT ANY WARRANTY without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  @author VolumeFi, Software inc.
#  @notice This Vyper contract is for Dancing Bananas.
#  SPDX-License-Identifier: Apache-2.0

# @version ^0.2.12

struct MintParams:
    token0: address
    token1: address
    fee: uint256
    tickLower: int128
    tickUpper: int128
    amount0Desired: uint256
    amount1Desired: uint256
    amount0Min: uint256
    amount1Min: uint256
    recipient: address
    deadline: uint256

struct SingleMintParams:
    token0: address
    token1: address
    fee: uint256
    tickLower: int128
    tickUpper: int128
    sqrtPriceAX96: uint256
    sqrtPriceBX96: uint256
    liquidityMin: uint256
    recipient: address
    deadline: uint256

struct RemoveParams:
    liquidity: uint256
    recipient: address
    deadline: uint256

interface WrappedEth:
    def deposit(): payable
    def withdraw(amount: uint256): nonpayable

interface NonfungiblePositionManager:
    def burn(tokenId: uint256): payable
    def ownerOf(tokenId: uint256) -> address: view

interface ERC20:
    def approve(account: address, amount: uint256): nonpayable
    def transfer(account: address, amount: uint256): nonpayable
    def transferFrom(_from: address, _to: address, amount: uint256): nonpayable

interface UniswapV2Factory:
    def getPair(tokenA: address, tokenB: address) -> address: view

interface UniswapV2Pair:
    def token0() -> address: view
    def getReserves() -> (uint256, uint256, uint256): view

interface Distributor:
    def distribute(addr: address): nonpayable

interface NANAGauge:
    def user_checkpoint(addr: address, action: uint256, token0: address, amount0: uint256, token1: address, amount1: uint256) -> uint256: nonpayable

event AddedLiquidity:
    tokenId: indexed(uint256)
    token0: indexed(address)
    token1: indexed(address)
    liquidity: uint256
    amount0: uint256
    amount1: uint256

event RemovedLiquidity:
    tokenId: indexed(uint256)
    token0: indexed(address)
    token1: indexed(address)
    liquidity: uint256
    amount0: uint256
    amount1: uint256

event Paused:
    paused: bool

event FeeChanged:
    newFee: uint256

NONFUNGIBLEPOSITIONMANAGER: constant(address) = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88
UNISWAPV3FACTORY: constant(address) = 0x1F98431c8aD98523631AE4a59f267346ea31F984
UNISWAPV2FACTORY: constant(address) = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
UNISWAPV2ROUTER02: constant(address) = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
VETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2

CAIPIN_MID: constant(Bytes[4]) = method_id("createAndInitializePoolIfNecessary(address,address,uint24,uint160)")
GETPOOL_MID: constant(Bytes[4]) = method_id("getPool(address,address,uint24)")
SLOT0_MID: constant(Bytes[4]) = method_id("slot0()")
MINT_MID: constant(Bytes[4]) = method_id("mint((address,address,uint24,int24,int24,uint256,uint256,uint256,uint256,address,uint256))")
INCREASELIQUIDITY_MID: constant(Bytes[4]) = method_id("increaseLiquidity((uint256,uint256,uint256,uint256,uint256,uint256))")
DECREASELIQUIDITY_MID: constant(Bytes[4]) = method_id("decreaseLiquidity((uint256,uint128,uint256,uint256,uint256))")
POSITIONS_MID: constant(Bytes[4]) = method_id("positions(uint256)")
COLLECT_MID: constant(Bytes[4]) = method_id("collect((uint256,address,uint128,uint128))")
SWAPETFT_MID: constant(Bytes[4]) = method_id("swapExactTokensForTokens(uint256,uint256,address[],address,uint256)")

ADDLIQETH_MID: constant(Bytes[4]) = method_id("addLiquidityEthForUniV3(uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,uint256,address,uint256))")
_ADDLIQETH_MID: constant(Bytes[4]) = method_id("addLiquidityEthForUniV3(uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,uint256,address,uint256),address)")
ADDLIQ_MID: constant(Bytes[4]) = method_id("addLiquidityForUniV3(uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,uint256,address,uint256))")
_ADDLIQ_MID: constant(Bytes[4]) = method_id("addLiquidityForUniV3(uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,uint256,address,uint256),address)")
INVEST_MID: constant(Bytes[4]) = method_id("investTokenForUniPair(uint256,address,uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,address,uint256))")
_INVEST_MID: constant(Bytes[4]) = method_id("investTokenForUniPair(uint256,address,uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,address,uint256),address)")
REMOVELIQ_MID: constant(Bytes[4]) = method_id("removeLiquidityFromUniV3NFLP(uint256,(uint256,address,uint256))")
REMOVELIQETH_MID: constant(Bytes[4]) = method_id("removeLiquidityEthFromUniV3NFLP(uint256,(uint256,address,uint256))")
DIVEST_MID: constant(Bytes[4]) = method_id("divestUniV3NFLPToToken(uint256,address,(uint256,address,uint256),uint256)")

USER_CHECKPOINT_MID: constant(Bytes[4]) = method_id("user_checkpoint(address,uint256,address,uint256,address,uint256)")

baseContract: public(address)
gauge: public(address)
distributor: public(address)
paused: public(bool)
admin: public(address)
feeAddress: public(address)
feeAmount: public(uint256)

@external
def __init__():
    self.paused = False
    self.admin = msg.sender
    self.feeAddress = 0xf29399fB3311082d9F8e62b988cBA44a5a98ebeD
    self.feeAmount = 5 * 10 ** 15

@external
@payable
@nonreentrant('lock')
def batchRun(data: Bytes[3616]):
    assert self.paused == False
    fee: uint256 = self.feeAmount
    assert msg.value >= fee
    send(self.feeAddress, fee)
    cursor: uint256 = 0
    usedValue: uint256 = fee
    _baseContract: address = self.baseContract
    _gauge: address = self.gauge
    for i in range(8):
        if len(data) < cursor + 4:
            break
        mid: Bytes[4] = slice(data, cursor, 4)
        cursor += 4
        if mid == ADDLIQ_MID:
            response128: Bytes[128] = raw_call(_baseContract,
                concat(
                    _ADDLIQ_MID,
                    slice(data, cursor, 384),
                    convert(msg.sender, bytes32)
                ),
                max_outsize=128
            )
            raw_call(
                _gauge,
                concat(
                    convert(msg.sender, bytes32),
                    convert(1, bytes32),
                    response128
                )
            )
            cursor += 384
        elif mid == ADDLIQETH_MID:
            if convert(convert(slice(data, cursor + 32, 32), uint256), address) == WETH:
                val: uint256 = convert(slice(data, cursor + 192, 32), uint256)
                response128: Bytes[128] = raw_call(_baseContract,
                    concat(
                        _ADDLIQETH_MID,
                        slice(data, cursor, 384),
                        convert(msg.sender, bytes32)
                    ),
                    value=val,
                    max_outsize=128
                )
                raw_call(
                    _gauge,
                    concat(
                        convert(msg.sender, bytes32),
                        convert(1, bytes32),
                        response128
                    )
                )                
                usedValue += val
            else:
                assert convert(convert(slice(data, cursor + 64, 32), uint256), address) == WETH
                val: uint256 = convert(slice(data, cursor + 224, 32), uint256)
                response128: Bytes[128] = raw_call(_baseContract,
                    concat(
                        _ADDLIQETH_MID,
                        slice(data, cursor, 384),
                        convert(msg.sender, bytes32)
                    ),
                    value=val,
                    max_outsize=128
                )
                raw_call(
                    _gauge,
                    concat(
                        convert(msg.sender, bytes32),
                        convert(1, bytes32),
                        response128
                    )
                )                
                usedValue += val
            cursor += 384
        elif mid == REMOVELIQ_MID:
            assert NonfungiblePositionManager(NONFUNGIBLEPOSITIONMANAGER).ownerOf(convert(slice(data, cursor, 32), uint256)) == msg.sender
            response128: Bytes[128] = raw_call(_baseContract,
                concat(
                    REMOVELIQ_MID,
                    slice(data, cursor, 128)
                ),
                max_outsize=128
            )
            raw_call(
                _gauge,
                concat(
                    convert(msg.sender, bytes32),
                    convert(2, bytes32),
                    response128
                )
            )
            cursor += 128
        elif mid == REMOVELIQETH_MID:
            assert NonfungiblePositionManager(NONFUNGIBLEPOSITIONMANAGER).ownerOf(convert(slice(data, cursor, 32), uint256)) == msg.sender
            response128: Bytes[128] = raw_call(_baseContract,
                concat(
                    REMOVELIQETH_MID,
                    slice(data, cursor, 128)
                ),
                max_outsize=128
            )
            raw_call(
                _gauge,
                concat(
                    convert(msg.sender, bytes32),
                    convert(2, bytes32),
                    response128
                )
            )
            cursor += 128
        elif mid == INVEST_MID:
            token: address = convert(convert(slice(data, cursor + 32, 32), uint256), address)
            if token == VETH or token == ZERO_ADDRESS:
                val: uint256 = convert(slice(data, cursor + 64, 32), uint256)
                response128: Bytes[128] = raw_call(_baseContract,
                    concat(
                        _INVEST_MID,
                        slice(data, cursor, 416),
                        convert(msg.sender, bytes32)
                    ),
                    value=val,
                    max_outsize=128
                )
                raw_call(
                    _gauge,
                    concat(
                        convert(msg.sender, bytes32),
                        convert(2, bytes32),
                        response128
                    )
                )
                usedValue += val
            else:
                response128: Bytes[128] = raw_call(_baseContract,
                    concat(
                        _INVEST_MID,
                        slice(data, cursor, 416),
                        convert(msg.sender, bytes32),
                        convert(0, bytes32)
                    ),
                    max_outsize=128
                )
                raw_call(
                    _gauge,
                    concat(
                        convert(msg.sender, bytes32),
                        convert(2, bytes32),
                        response128
                    )
                )
            cursor += 416
        elif mid == DIVEST_MID:
            assert NonfungiblePositionManager(NONFUNGIBLEPOSITIONMANAGER).ownerOf(convert(slice(data, cursor, 32), uint256)) == msg.sender
            response128: Bytes[128] = raw_call(_baseContract,
                concat(
                    DIVEST_MID,
                    slice(data, cursor, 192)
                ),
                max_outsize=128
            )
            raw_call(
                _gauge,
                concat(
                    convert(msg.sender, bytes32),
                    convert(2, bytes32),
                    response128
                )
            )
            cursor += 192
        else:
            assert convert(mid, uint256) == 0
            break
    Distributor(self.distributor).distribute(msg.sender)

    if msg.value - usedValue > 0:
        send(msg.sender, msg.value - usedValue)

# Admin functions
@external
def pause(_paused: bool):
    assert msg.sender == self.admin
    self.paused = _paused
    log Paused(_paused)

@external
def newBaseContract(_baseContract: address):
    assert msg.sender == self.admin
    self.baseContract = _baseContract

@external
def newGauge(_gauge: address):
    assert msg.sender == self.admin
    self.gauge = _gauge

@external
def newAdmin(_admin: address):
    assert msg.sender == self.admin
    self.admin = _admin

@external
def newFeeAmount(_feeAmount: uint256):
    assert msg.sender == self.admin
    self.feeAmount = _feeAmount
    log FeeChanged(_feeAmount)

@external
def newFeeAddress(_feeAddress: address):
    assert msg.sender == self.admin
    self.feeAddress = _feeAddress

@external
@nonreentrant('lock')
def batchWithdraw(token: address[8], amount: uint256[8], to: address[8]):
    assert msg.sender == self.admin
    for i in range(8):
        if token[i] == VETH:
            send(to[i], amount[i])
        elif token[i] != ZERO_ADDRESS:
            ERC20(token[i]).transfer(to[i], amount[i])

@external
@nonreentrant('lock')
def withdraw(token: address, amount: uint256, to: address):
    assert msg.sender == self.admin
    if token == VETH:
        send(to, amount)
    elif token != ZERO_ADDRESS:
        ERC20(token).transfer(to, amount)

@external
@payable
def __default__():
    assert msg.sender == WETH
