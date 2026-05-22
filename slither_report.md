**THIS CHECKLIST IS NOT COMPLETE**. Use `--show-ignored-findings` to show all the results.
Summary
 - [arbitrary-send-erc20](#arbitrary-send-erc20) (1 results) (High)
 - [incorrect-exp](#incorrect-exp) (1 results) (High)
 - [unchecked-transfer](#unchecked-transfer) (25 results) (High)
 - [uninitialized-state](#uninitialized-state) (1 results) (High)
 - [divide-before-multiply](#divide-before-multiply) (16 results) (Medium)
 - [incorrect-equality](#incorrect-equality) (3 results) (Medium)
 - [reentrancy-no-eth](#reentrancy-no-eth) (21 results) (Medium)
 - [unused-return](#unused-return) (11 results) (Medium)
 - [shadowing-local](#shadowing-local) (3 results) (Low)
 - [events-maths](#events-maths) (8 results) (Low)
 - [missing-zero-check](#missing-zero-check) (16 results) (Low)
 - [calls-loop](#calls-loop) (15 results) (Low)
 - [reentrancy-benign](#reentrancy-benign) (9 results) (Low)
 - [reentrancy-events](#reentrancy-events) (6 results) (Low)
 - [timestamp](#timestamp) (18 results) (Low)
 - [assembly](#assembly) (5 results) (Informational)
 - [pragma](#pragma) (1 results) (Informational)
 - [costly-loop](#costly-loop) (4 results) (Informational)
 - [solc-version](#solc-version) (3 results) (Informational)
 - [low-level-calls](#low-level-calls) (6 results) (Informational)
 - [missing-inheritance](#missing-inheritance) (1 results) (Informational)
 - [naming-convention](#naming-convention) (29 results) (Informational)
 - [too-many-digits](#too-many-digits) (1 results) (Informational)
 - [constable-states](#constable-states) (2 results) (Optimization)
 - [immutable-states](#immutable-states) (1 results) (Optimization)
## arbitrary-send-erc20
Impact: High
Confidence: High
 - [ ] ID-0
[XPLUSToken._swapAndLiquify(uint256)](src/Token/XPULS.sol#L362-L396) uses arbitrary from in transferFrom: [IERC20(USDT).transferFrom(address(distributor),address(this),newBalance)](src/Token/XPULS.sol#L376-L380)

src/Token/XPULS.sol#L362-L396


## incorrect-exp
Impact: High
Confidence: Medium
 - [ ] ID-1
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) has bitwise-xor operator ^ instead of the exponentiation operator **: 
	 - [inverse = (3 * denominator) ^ 2](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L116)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


## unchecked-transfer
Impact: High
Confidence: Medium
 - [ ] ID-2
[Staking._distributeS7Rewards()](src/Staking.sol#L501-L524) ignores return value by [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)

src/Staking.sol#L501-L524


 - [ ] ID-3
[Staking.emergencyWithdraw(address,uint256)](src/Staking.sol#L843-L849) ignores return value by [IERC20(token).transfer(owner(),amount)](src/Staking.sol#L847)

src/Staking.sol#L843-L849


 - [ ] ID-4
[YPlusSwap.sell(uint256)](src/yplusSwap.sol#L182-L210) ignores return value by [XPLUS.transfer(msg.sender,xplusAmount)](src/yplusSwap.sol#L207)

src/yplusSwap.sol#L182-L210


 - [ ] ID-5
[Staking.claimReward(uint256)](src/Staking.sol#L308-L353) ignores return value by [USDT.transfer(msg.sender,actualReward)](src/Staking.sol#L342)

src/Staking.sol#L308-L353


 - [ ] ID-6
[Staking._distributeTeamRewards(address,uint256)](src/Staking.sol#L459-L499) ignores return value by [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)

src/Staking.sol#L459-L499


 - [ ] ID-7
[Node.claimNodeReward(uint256)](src/Node.sol#L79-L99) ignores return value by [USDT.transfer(msg.sender,reward)](src/Node.sol#L96)

src/Node.sol#L79-L99


 - [ ] ID-8
[Node.transferNode(uint256,address)](src/Node.sol#L142-L175) ignores return value by [USDT.transfer(msg.sender,reward)](src/Node.sol#L155)

src/Node.sol#L142-L175


 - [ ] ID-9
[Staking._distributeGenerationRewards(address,uint256)](src/Staking.sol#L441-L457) ignores return value by [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)

src/Staking.sol#L441-L457


 - [ ] ID-10
[YPlusSwap.sell(uint256)](src/yplusSwap.sol#L182-L210) ignores return value by [YPLUS.transfer(0x000000000000000000000000000000000000dEaD,burnTax)](src/yplusSwap.sol#L203)

src/yplusSwap.sol#L182-L210


 - [ ] ID-11
[Staking._distributeS7Rewards()](src/Staking.sol#L501-L524) ignores return value by [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)

src/Staking.sol#L501-L524


 - [ ] ID-12
[Staking.manualAllocation()](src/Staking.sol#L712-L733) ignores return value by [USDT.transfer(pair,remainingUsdt)](src/Staking.sol#L729)

src/Staking.sol#L712-L733


 - [ ] ID-13
[YPlusSwap.sell(uint256)](src/yplusSwap.sol#L182-L210) ignores return value by [YPLUS.transferFrom(msg.sender,address(this),yplusAmount)](src/yplusSwap.sol#L200)

src/yplusSwap.sol#L182-L210


 - [ ] ID-14
[Staking.manualAllocation()](src/Staking.sol#L712-L733) ignores return value by [USDT.transfer(address(yplusSwap),accumulatedYplusFee)](src/Staking.sol#L716)

src/Staking.sol#L712-L733


 - [ ] ID-15
[XPLUSToken._swapAndLiquify(uint256)](src/Token/XPULS.sol#L362-L396) ignores return value by [IERC20(USDT).transferFrom(address(distributor),address(this),newBalance)](src/Token/XPULS.sol#L376-L380)

src/Token/XPULS.sol#L362-L396


 - [ ] ID-16
[Node.emergencyWithdraw(address,uint256)](src/Node.sol#L179-L185) ignores return value by [IERC20(token).transfer(owner(),amount)](src/Node.sol#L183)

src/Node.sol#L179-L185


 - [ ] ID-17
[Staking._distributeGenerationRewards(address,uint256)](src/Staking.sol#L441-L457) ignores return value by [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)

src/Staking.sol#L441-L457


 - [ ] ID-18
[XPLUSToken.emergencyWithdraw(address,uint256)](src/Token/XPULS.sol#L486-L496) ignores return value by [IERC20(token).transfer(owner(),amount)](src/Token/XPULS.sol#L494)

src/Token/XPULS.sol#L486-L496


 - [ ] ID-19
[YPlusSwap.sell(uint256)](src/yplusSwap.sol#L182-L210) ignores return value by [YPLUS.transfer(marketingAddress,marketingTax)](src/yplusSwap.sol#L204)

src/yplusSwap.sol#L182-L210


 - [ ] ID-20
[YPlusSwap.emergencyWithdraw(address,uint256)](src/yplusSwap.sol#L252-L258) ignores return value by [IERC20(token).transfer(owner(),amount)](src/yplusSwap.sol#L256)

src/yplusSwap.sol#L252-L258


 - [ ] ID-21
[Staking.stake(uint256,uint256)](src/Staking.sol#L144-L185) ignores return value by [USDT.transferFrom(msg.sender,address(this),amount)](src/Staking.sol#L152)

src/Staking.sol#L144-L185


 - [ ] ID-22
[Staking._distributeTeamRewards(address,uint256)](src/Staking.sol#L459-L499) ignores return value by [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)

src/Staking.sol#L459-L499


 - [ ] ID-23
[YPlusSwap._executeBuy(uint256)](src/yplusSwap.sol#L162-L176) ignores return value by [XPLUS.transferFrom(msg.sender,address(this),xplusAmount)](src/yplusSwap.sol#L170)

src/yplusSwap.sol#L162-L176


 - [ ] ID-24
[Staking.withdraw(uint256)](src/Staking.sol#L355-L409) ignores return value by [USDT.transfer(msg.sender,principal + actualReward)](src/Staking.sol#L394)

src/Staking.sol#L355-L409


 - [ ] ID-25
[Staking.stakeForUSDT(uint256)](src/Staking.sol#L779-L784) ignores return value by [USDT.transferFrom(msg.sender,address(this),amount)](src/Staking.sol#L782)

src/Staking.sol#L779-L784


 - [ ] ID-26
[YPlusSwap._executeBuy(uint256)](src/yplusSwap.sol#L162-L176) ignores return value by [YPLUS.transfer(msg.sender,yplusAmount)](src/yplusSwap.sol#L172)

src/yplusSwap.sol#L162-L176


## uninitialized-state
Impact: High
Confidence: High
 - [ ] ID-27
[XPLUSToken.lastBuyTime](src/Token/XPULS.sol#L60) is never initialized. It is used in:
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)

src/Token/XPULS.sol#L60


## divide-before-multiply
Impact: Medium
Confidence: Medium
 - [ ] ID-28
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L101)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-29
[XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298) performs a multiplication on the result of a division:
	- [totalBuyFee = (amount * totalBuyTaxRate) / 10000](src/Token/XPULS.sol#L205)
	- [injectYplusFee = (totalBuyFee * 10) / 35](src/Token/XPULS.sol#L208)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-30
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L101)
	- [inverse = (3 * denominator) ^ 2](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L116)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-31
[XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298) performs a multiplication on the result of a division:
	- [baseSellTax = (amount * totalSellTaxRate) / 10000](src/Token/XPULS.sol#L235)
	- [burnFee = (baseSellTax * 10) / 35](src/Token/XPULS.sol#L237)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-32
[XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298) performs a multiplication on the result of a division:
	- [profitTax = (amountAfterBaseTax * totalProfitTaxRate) / 10000](src/Token/XPULS.sol#L270)
	- [marketingAmount = (profitTax * 8) / 28](src/Token/XPULS.sol#L277)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-33
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L101)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L120)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-34
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L101)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L121)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-35
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L101)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L122)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-36
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) performs a multiplication on the result of a division:
	- [prod0 = prod0 / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L104)
	- [result = prod0 * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L131)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-37
[XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298) performs a multiplication on the result of a division:
	- [profitTax = (amountAfterBaseTax * totalProfitTaxRate) / 10000](src/Token/XPULS.sol#L270)
	- [injectAmount = (profitTax * 4) / 28](src/Token/XPULS.sol#L281)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-38
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L101)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L125)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-39
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L101)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L124)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-40
[Staking._powu(uint256,uint256)](src/Staking.sol#L292-L301) performs a multiplication on the result of a division:
	- [result = (result * base) / 1e18](src/Staking.sol#L296)
	- [base = (base * base) / 1e18](src/Staking.sol#L298)

src/Staking.sol#L292-L301


 - [ ] ID-41
[XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298) performs a multiplication on the result of a division:
	- [profitTax = (amountAfterBaseTax * totalProfitTaxRate) / 10000](src/Token/XPULS.sol#L270)
	- [nodeAmount = (profitTax * 8) / 28](src/Token/XPULS.sol#L279)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-42
[XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298) performs a multiplication on the result of a division:
	- [baseSellTax = (amount * totalSellTaxRate) / 10000](src/Token/XPULS.sol#L235)
	- [marketingFee = (baseSellTax * 15) / 35](src/Token/XPULS.sol#L239)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-43
[YPlusSwap.getYPlusPrice()](src/yplusSwap.sol#L99-L106) performs a multiplication on the result of a division:
	- [priceInXPlus = (xplusPoolBalance * 1e18) / circulatingSupply](src/yplusSwap.sol#L104)
	- [(priceInXPlus * getXPlusPrice()) / 1e18](src/yplusSwap.sol#L105)

src/yplusSwap.sol#L99-L106


## incorrect-equality
Impact: Medium
Confidence: High
 - [ ] ID-44
[FirstLaunch.launch()](src/Token/XPULS.sol#L19-L22) uses a dangerous strict equality:
	- [require(bool,string)(launchedAtTimestamp == 0,Already launched)](src/Token/XPULS.sol#L20)

src/Token/XPULS.sol#L19-L22


 - [ ] ID-45
[Staking.calculateReward(address,uint256)](src/Staking.sol#L267-L290) uses a dangerous strict equality:
	- [timeElapsed == 0](src/Staking.sol#L276)

src/Staking.sol#L267-L290


 - [ ] ID-46
[YPlusSwap.getYPlusPrice()](src/yplusSwap.sol#L99-L106) uses a dangerous strict equality:
	- [circulatingSupply == 0](src/yplusSwap.sol#L101)

src/yplusSwap.sol#L99-L106


## reentrancy-no-eth
Impact: Medium
Confidence: Medium
 - [ ] ID-47
Reentrancy in [NoahNFT.mintBatch(address,string[])](src/NoahNFT.sol#L117-L145):
	External calls:
	- [usdtToken.safeTransferFrom(msg.sender,address(this),totalPrice)](src/NoahNFT.sol#L123)
	- [_safeMint(to,nextTokenId)](src/NoahNFT.sol#L128)
		- [retval = IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L406-L417)
	State variables written after the call(s):
	- [_addTokenToOwnerEnumeration(to,nextTokenId)](src/NoahNFT.sol#L132)
		- [_ownedTokens[to].push(tokenId)](src/NoahNFT.sol#L226)
	[NoahNFT._ownedTokens](src/NoahNFT.sol#L25) can be used in cross function reentrancies:
	- [NoahNFT._addTokenToOwnerEnumeration(address,uint256)](src/NoahNFT.sol#L224-L227)
	- [NoahNFT._removeTokenFromOwnerEnumeration(address,uint256)](src/NoahNFT.sol#L229-L241)
	- [NoahNFT.getOwnedNFTs(address)](src/NoahNFT.sol#L220-L222)
	- [mintedTokenIds.push(nextTokenId)](src/NoahNFT.sol#L141)
	[NoahNFT.mintedTokenIds](src/NoahNFT.sol#L39) can be used in cross function reentrancies:
	- [NoahNFT.getMintRecordsByPage(uint256,uint256)](src/NoahNFT.sol#L251-L262)
	- [NoahNFT.getMintedTokenIdsLength()](src/NoahNFT.sol#L264-L266)
	- [NoahNFT.mint(address,string)](src/NoahNFT.sol#L93-L115)
	- [NoahNFT.mintBatch(address,string[])](src/NoahNFT.sol#L117-L145)
	- [NoahNFT.mintedTokenIds](src/NoahNFT.sol#L39)
	- [nextTokenId ++](src/NoahNFT.sol#L143)
	[NoahNFT.nextTokenId](src/NoahNFT.sol#L15) can be used in cross function reentrancies:
	- [NoahNFT.mint(address,string)](src/NoahNFT.sol#L93-L115)
	- [NoahNFT.mintBatch(address,string[])](src/NoahNFT.sol#L117-L145)
	- [NoahNFT.nextTokenId](src/NoahNFT.sol#L15)
	- [userMintedTokenIds[msg.sender].push(nextTokenId)](src/NoahNFT.sol#L142)
	[NoahNFT.userMintedTokenIds](src/NoahNFT.sol#L40) can be used in cross function reentrancies:
	- [NoahNFT.getUserMintRecordsByPage(address,uint256,uint256)](src/NoahNFT.sol#L147-L161)
	- [NoahNFT.getUserMintedTokenIdsLength(address)](src/NoahNFT.sol#L163-L166)
	- [NoahNFT.mint(address,string)](src/NoahNFT.sol#L93-L115)
	- [NoahNFT.mintBatch(address,string[])](src/NoahNFT.sol#L117-L145)
	- [NoahNFT.userMintedTokenIds](src/NoahNFT.sol#L40)

src/NoahNFT.sol#L117-L145


 - [ ] ID-48
Reentrancy in [NoahNFT.mint(address,string)](src/NoahNFT.sol#L93-L115):
	External calls:
	- [usdtToken.safeTransferFrom(msg.sender,address(this),usdt_30)](src/NoahNFT.sol#L97)
	- [_safeMint(to,nextTokenId)](src/NoahNFT.sol#L99)
		- [retval = IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L406-L417)
	State variables written after the call(s):
	- [nextTokenId ++](src/NoahNFT.sol#L114)
	[NoahNFT.nextTokenId](src/NoahNFT.sol#L15) can be used in cross function reentrancies:
	- [NoahNFT.mint(address,string)](src/NoahNFT.sol#L93-L115)
	- [NoahNFT.mintBatch(address,string[])](src/NoahNFT.sol#L117-L145)
	- [NoahNFT.nextTokenId](src/NoahNFT.sol#L15)

src/NoahNFT.sol#L93-L115


 - [ ] ID-49
Reentrancy in [Staking._distributeS7Rewards()](src/Staking.sol#L501-L524):
	External calls:
	- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
	State variables written after the call(s):
	- [accumulatedS7Reward = 0](src/Staking.sol#L523)
	[Staking.accumulatedS7Reward](src/Staking.sol#L60) can be used in cross function reentrancies:
	- [Staking.accumulatedS7Reward](src/Staking.sol#L60)

src/Staking.sol#L501-L524


 - [ ] ID-50
Reentrancy in [Staking.manualAllocation()](src/Staking.sol#L712-L733):
	External calls:
	- [_distributeS7Rewards()](src/Staking.sol#L713)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
	- [USDT.transfer(address(yplusSwap),accumulatedYplusFee)](src/Staking.sol#L716)
	State variables written after the call(s):
	- [accumulatedYplusFee = 0](src/Staking.sol#L717)
	[Staking.accumulatedYplusFee](src/Staking.sol#L58) can be used in cross function reentrancies:
	- [Staking.accumulatedYplusFee](src/Staking.sol#L58)

src/Staking.sol#L712-L733


 - [ ] ID-51
Reentrancy in [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338):
	External calls:
	- [_swapTokensForUSDT(accumulatedMarketingFee,marketingAddress)](src/Token/XPULS.sol#L320)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapTokensForUSDT(accumulatedNodeFee,nodeAddress)](src/Token/XPULS.sol#L325)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	State variables written after the call(s):
	- [accumulatedNodeFee = 0](src/Token/XPULS.sol#L326)
	[XPLUSToken.accumulatedNodeFee](src/Token/XPULS.sol#L71) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedNodeFee](src/Token/XPULS.sol#L71)

src/Token/XPULS.sol#L312-L338


 - [ ] ID-52
Reentrancy in [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338):
	External calls:
	- [_swapTokensForUSDT(accumulatedMarketingFee,marketingAddress)](src/Token/XPULS.sol#L320)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapTokensForUSDT(accumulatedNodeFee,nodeAddress)](src/Token/XPULS.sol#L325)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapTokensForUSDT(accumulatedProtectionFee,protectionFundAddress)](src/Token/XPULS.sol#L330)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	State variables written after the call(s):
	- [accumulatedProtectionFee = 0](src/Token/XPULS.sol#L331)
	[XPLUSToken.accumulatedProtectionFee](src/Token/XPULS.sol#L73) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedProtectionFee](src/Token/XPULS.sol#L73)

src/Token/XPULS.sol#L312-L338


 - [ ] ID-53
Reentrancy in [Staking.withdraw(uint256)](src/Staking.sol#L355-L409):
	External calls:
	- [router.swapTokensForExactTokens(totalReward,xplusBefore,path,address(this),block.timestamp)](src/Staking.sol#L374-L380)
	- [_distributeRewards(msg.sender,distributePortion)](src/Staking.sol#L391)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
		- [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
		- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
		- [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)
	- [USDT.transfer(msg.sender,principal + actualReward)](src/Staking.sol#L394)
	- [XPLUS.recycleLiquidity(xplusUsed)](src/Staking.sol#L396)
	State variables written after the call(s):
	- [order.isWithdrawn = true](src/Staking.sol#L398)
	[Staking.userOrders](src/Staking.sol#L42) can be used in cross function reentrancies:
	- [Staking.calculateReward(address,uint256)](src/Staking.sol#L267-L290)
	- [Staking.getUserOrders(address)](src/Staking.sol#L735-L737)
	- [Staking.getUserStats(address)](src/Staking.sol#L739-L756)
	- [Staking.userOrders](src/Staking.sol#L42)
	- [order.lastClaimTime = block.timestamp](src/Staking.sol#L399)
	[Staking.userOrders](src/Staking.sol#L42) can be used in cross function reentrancies:
	- [Staking.calculateReward(address,uint256)](src/Staking.sol#L267-L290)
	- [Staking.getUserOrders(address)](src/Staking.sol#L735-L737)
	- [Staking.getUserStats(address)](src/Staking.sol#L739-L756)
	- [Staking.userOrders](src/Staking.sol#L42)
	- [order.claimedReward += actualReward](src/Staking.sol#L400)
	[Staking.userOrders](src/Staking.sol#L42) can be used in cross function reentrancies:
	- [Staking.calculateReward(address,uint256)](src/Staking.sol#L267-L290)
	- [Staking.getUserOrders(address)](src/Staking.sol#L735-L737)
	- [Staking.getUserStats(address)](src/Staking.sol#L739-L756)
	- [Staking.userOrders](src/Staking.sol#L42)

src/Staking.sol#L355-L409


 - [ ] ID-54
Reentrancy in [Staking._distributeRewards(address,uint256)](src/Staking.sol#L418-L439):
	External calls:
	- [_distributeGenerationRewards(user,generationReward)](src/Staking.sol#L420)
		- [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
		- [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)
	- [_distributeTeamRewards(user,teamReward)](src/Staking.sol#L423)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
		- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
		- [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)
	- [_swapUsdtForTokens(accumulatedYplusFee,address(yplusSwap))](src/Staking.sol#L429)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
	State variables written after the call(s):
	- [accumulatedYplusFee = 0](src/Staking.sol#L430)
	[Staking.accumulatedYplusFee](src/Staking.sol#L58) can be used in cross function reentrancies:
	- [Staking.accumulatedYplusFee](src/Staking.sol#L58)

src/Staking.sol#L418-L439


 - [ ] ID-55
Reentrancy in [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298):
	External calls:
	- [_swapAndDistribute()](src/Token/XPULS.sol#L232)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
		- [IERC20(USDT).transferFrom(address(distributor),address(this),newBalance)](src/Token/XPULS.sol#L376-L380)
		- [uniswapV2Router.addLiquidity(address(this),USDT,otherHalf,newBalance,0,0,address(0xdead),block.timestamp)](src/Token/XPULS.sol#L383-L392)
	State variables written after the call(s):
	- [super._transfer(sender,address(0xdead),burnFee)](src/Token/XPULS.sol#L243)
		- [_balances[from] = fromBalance - amount](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L231)
		- [_balances[to] += amount](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L234)
	[ERC20._balances](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L39) can be used in cross function reentrancies:
	- [ERC20._mint(address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L251-L264)
	- [ERC20._transfer(address,address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L222-L240)
	- [ERC20.balanceOf(address)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L101-L103)
	- [super._transfer(sender,address(this),marketingFee + nodeFee)](src/Token/XPULS.sol#L244)
		- [_balances[from] = fromBalance - amount](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L231)
		- [_balances[to] += amount](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L234)
	[ERC20._balances](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L39) can be used in cross function reentrancies:
	- [ERC20._mint(address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L251-L264)
	- [ERC20._transfer(address,address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L222-L240)
	- [ERC20.balanceOf(address)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L101-L103)
	- [super._transfer(sender,address(this),profitTax)](src/Token/XPULS.sol#L275)
		- [_balances[from] = fromBalance - amount](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L231)
		- [_balances[to] += amount](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L234)
	[ERC20._balances](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L39) can be used in cross function reentrancies:
	- [ERC20._mint(address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L251-L264)
	- [ERC20._transfer(address,address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L222-L240)
	- [ERC20.balanceOf(address)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L101-L103)
	- [super._transfer(sender,recipient,amount - baseSellTax - profitTax)](src/Token/XPULS.sol#L290-L294)
		- [_balances[from] = fromBalance - amount](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L231)
		- [_balances[to] += amount](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L234)
	[ERC20._balances](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L39) can be used in cross function reentrancies:
	- [ERC20._mint(address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L251-L264)
	- [ERC20._transfer(address,address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L222-L240)
	- [ERC20.balanceOf(address)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L101-L103)
	- [accumulatedInjectYplusFee += injectAmount](src/Token/XPULS.sol#L286)
	[XPLUSToken.accumulatedInjectYplusFee](src/Token/XPULS.sol#L69) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedInjectYplusFee](src/Token/XPULS.sol#L69)
	- [accumulatedMarketingFee += marketingFee](src/Token/XPULS.sol#L245)
	[XPLUSToken.accumulatedMarketingFee](src/Token/XPULS.sol#L70) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedMarketingFee](src/Token/XPULS.sol#L70)
	- [accumulatedMarketingFee += marketingAmount](src/Token/XPULS.sol#L284)
	[XPLUSToken.accumulatedMarketingFee](src/Token/XPULS.sol#L70) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedMarketingFee](src/Token/XPULS.sol#L70)
	- [accumulatedNodeFee += nodeFee](src/Token/XPULS.sol#L246)
	[XPLUSToken.accumulatedNodeFee](src/Token/XPULS.sol#L71) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedNodeFee](src/Token/XPULS.sol#L71)
	- [accumulatedNodeFee += nodeAmount](src/Token/XPULS.sol#L285)
	[XPLUSToken.accumulatedNodeFee](src/Token/XPULS.sol#L71) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedNodeFee](src/Token/XPULS.sol#L71)
	- [accumulatedProtectionFee += protectionAmount](src/Token/XPULS.sol#L287)
	[XPLUSToken.accumulatedProtectionFee](src/Token/XPULS.sol#L73) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedProtectionFee](src/Token/XPULS.sol#L73)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-56
Reentrancy in [Staking._distributeTeamRewards(address,uint256)](src/Staking.sol#L459-L499):
	External calls:
	- [_distributeS7Rewards()](src/Staking.sol#L479)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
	- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
	State variables written after the call(s):
	- [accumulatedS7Reward += reward](src/Staking.sol#L475)
	[Staking.accumulatedS7Reward](src/Staking.sol#L60) can be used in cross function reentrancies:
	- [Staking.accumulatedS7Reward](src/Staking.sol#L60)
	- [_distributeS7Rewards()](src/Staking.sol#L479)
		- [accumulatedS7Reward = 0](src/Staking.sol#L508)
		- [accumulatedS7Reward = 0](src/Staking.sol#L523)
	[Staking.accumulatedS7Reward](src/Staking.sol#L60) can be used in cross function reentrancies:
	- [Staking.accumulatedS7Reward](src/Staking.sol#L60)

src/Staking.sol#L459-L499


 - [ ] ID-57
Reentrancy in [Staking.claimReward(uint256)](src/Staking.sol#L308-L353):
	External calls:
	- [router.swapTokensForExactTokens(reward,xplusBefore,path,address(this),block.timestamp)](src/Staking.sol#L328-L334)
	- [USDT.transfer(msg.sender,actualReward)](src/Staking.sol#L342)
	- [_distributeRewards(msg.sender,distributePortion)](src/Staking.sol#L345)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
		- [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
		- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
		- [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)
	- [XPLUS.recycleLiquidity(xplusUsed)](src/Staking.sol#L348)
	State variables written after the call(s):
	- [userTotalWithdrawn[msg.sender] += actualReward](src/Staking.sol#L350)
	[Staking.userTotalWithdrawn](src/Staking.sol#L46) can be used in cross function reentrancies:
	- [Staking.getUserStats(address)](src/Staking.sol#L739-L756)
	- [Staking.userTotalWithdrawn](src/Staking.sol#L46)

src/Staking.sol#L308-L353


 - [ ] ID-58
Reentrancy in [Node.transferNode(uint256,address)](src/Node.sol#L142-L175):
	External calls:
	- [USDT.transfer(msg.sender,reward)](src/Node.sol#L155)
	State variables written after the call(s):
	- [isNode[msg.sender] = false](src/Node.sol#L167)
	[Node.isNode](src/Node.sol#L26) can be used in cross function reentrancies:
	- [Node.addNode(address)](src/Node.sol#L103-L122)
	- [Node.isNode](src/Node.sol#L26)
	- [isNode[newOwner] = true](src/Node.sol#L172)
	[Node.isNode](src/Node.sol#L26) can be used in cross function reentrancies:
	- [Node.addNode(address)](src/Node.sol#L103-L122)
	- [Node.isNode](src/Node.sol#L26)
	- [node.owner = newOwner](src/Node.sol#L170)
	[Node.nodes](src/Node.sol#L24) can be used in cross function reentrancies:
	- [Node.addNode(address)](src/Node.sol#L103-L122)
	- [Node.nodes](src/Node.sol#L24)
	- [Node.pendingReward(uint256)](src/Node.sol#L65-L74)
	- [Node.setNodeActive(uint256,bool)](src/Node.sol#L135-L138)

src/Node.sol#L142-L175


 - [ ] ID-59
Reentrancy in [Staking._distributeRewards(address,uint256)](src/Staking.sol#L418-L439):
	External calls:
	- [_distributeGenerationRewards(user,generationReward)](src/Staking.sol#L420)
		- [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
		- [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)
	- [_distributeTeamRewards(user,teamReward)](src/Staking.sol#L423)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
		- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
		- [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)
	- [_swapUsdtForTokens(accumulatedYplusFee,address(yplusSwap))](src/Staking.sol#L429)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
	- [_swapUsdtForTokens(accumulatedXplusFee,xplusAirdropAddress)](src/Staking.sol#L436)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
	State variables written after the call(s):
	- [accumulatedXplusFee = 0](src/Staking.sol#L437)
	[Staking.accumulatedXplusFee](src/Staking.sol#L59) can be used in cross function reentrancies:
	- [Staking.accumulatedXplusFee](src/Staking.sol#L59)

src/Staking.sol#L418-L439


 - [ ] ID-60
Reentrancy in [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338):
	External calls:
	- [_swapTokensForUSDT(accumulatedMarketingFee,marketingAddress)](src/Token/XPULS.sol#L320)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	State variables written after the call(s):
	- [accumulatedMarketingFee = 0](src/Token/XPULS.sol#L321)
	[XPLUSToken.accumulatedMarketingFee](src/Token/XPULS.sol#L70) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedMarketingFee](src/Token/XPULS.sol#L70)

src/Token/XPULS.sol#L312-L338


 - [ ] ID-61
Reentrancy in [Staking._updatePerformance(address,uint256,bool)](src/Staking.sol#L543-L574):
	External calls:
	- [_checkAndUpdateLevel(uplines[i])](src/Staking.sol#L572)
		- [yplusSwap.addOneTimeBuyQuota(user,quota)](src/Staking.sol#L609)
	State variables written after the call(s):
	- [directPerformance[uplines[i]] += amount](src/Staking.sol#L550)
	[Staking.directPerformance](src/Staking.sol#L66) can be used in cross function reentrancies:
	- [Staking.directPerformance](src/Staking.sol#L66)
	- [directPerformance[uplines[i]] -= amount](src/Staking.sol#L553)
	[Staking.directPerformance](src/Staking.sol#L66) can be used in cross function reentrancies:
	- [Staking.directPerformance](src/Staking.sol#L66)
	- [directPerformance[uplines[i]] = 0](src/Staking.sol#L555)
	[Staking.directPerformance](src/Staking.sol#L66) can be used in cross function reentrancies:
	- [Staking.directPerformance](src/Staking.sol#L66)
	- [teamPerformance[uplines[i]] += amount](src/Staking.sol#L561)
	[Staking.teamPerformance](src/Staking.sol#L64) can be used in cross function reentrancies:
	- [Staking.teamPerformance](src/Staking.sol#L64)
	- [teamPerformance[uplines[i]] -= amount](src/Staking.sol#L564)
	[Staking.teamPerformance](src/Staking.sol#L64) can be used in cross function reentrancies:
	- [Staking.teamPerformance](src/Staking.sol#L64)
	- [teamPerformance[uplines[i]] = 0](src/Staking.sol#L566)
	[Staking.teamPerformance](src/Staking.sol#L64) can be used in cross function reentrancies:
	- [Staking.teamPerformance](src/Staking.sol#L64)
	- [_updateZonePerformance(uplines[i])](src/Staking.sol#L570)
		- [zonePerformance[user] = totalBranchPerformance - maxBranchPerformance](src/Staking.sol#L589)
	[Staking.zonePerformance](src/Staking.sol#L68) can be used in cross function reentrancies:
	- [Staking._checkAndUpdateLevel(address)](src/Staking.sol#L592-L624)
	- [Staking.calculateUserLevel(address)](src/Staking.sol#L707-L710)
	- [Staking.getUserLevelInfo(address)](src/Staking.sol#L671-L696)
	- [Staking.zonePerformance](src/Staking.sol#L68)

src/Staking.sol#L543-L574


 - [ ] ID-62
Reentrancy in [Staking.withdraw(uint256)](src/Staking.sol#L355-L409):
	External calls:
	- [router.swapTokensForExactTokens(totalReward,xplusBefore,path,address(this),block.timestamp)](src/Staking.sol#L374-L380)
	- [_distributeRewards(msg.sender,distributePortion)](src/Staking.sol#L391)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
		- [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
		- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
		- [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)
	- [USDT.transfer(msg.sender,principal + actualReward)](src/Staking.sol#L394)
	- [XPLUS.recycleLiquidity(xplusUsed)](src/Staking.sol#L396)
	- [_updatePerformance(msg.sender,principal,false)](src/Staking.sol#L404)
		- [yplusSwap.addOneTimeBuyQuota(user,quota)](src/Staking.sol#L609)
	State variables written after the call(s):
	- [_updatePerformance(msg.sender,principal,false)](src/Staking.sol#L404)
		- [s7Users.push(user)](src/Staking.sol#L638)
		- [s7Users[index] = lastUser](src/Staking.sol#L651)
		- [s7Users.pop()](src/Staking.sol#L655)
	[Staking.s7Users](src/Staking.sol#L83) can be used in cross function reentrancies:
	- [Staking._addS7User(address)](src/Staking.sol#L635-L642)
	- [Staking._removeS7User(address)](src/Staking.sol#L644-L661)
	- [Staking.s7Users](src/Staking.sol#L83)
	- [_updatePerformance(msg.sender,principal,false)](src/Staking.sol#L404)
		- [userLevel[user] = newLevel](src/Staking.sol#L598)
	[Staking.userLevel](src/Staking.sol#L79) can be used in cross function reentrancies:
	- [Staking._checkAndUpdateLevel(address)](src/Staking.sol#L592-L624)
	- [Staking.getUserLevel(address)](src/Staking.sol#L667-L669)
	- [Staking.getUserLevelInfo(address)](src/Staking.sol#L671-L696)
	- [Staking.userLevel](src/Staking.sol#L79)
	- [userTotalWithdrawn[msg.sender] += actualReward](src/Staking.sol#L406)
	[Staking.userTotalWithdrawn](src/Staking.sol#L46) can be used in cross function reentrancies:
	- [Staking.getUserStats(address)](src/Staking.sol#L739-L756)
	- [Staking.userTotalWithdrawn](src/Staking.sol#L46)

src/Staking.sol#L355-L409


 - [ ] ID-63
Reentrancy in [YPlusSwap._executeBuy(uint256)](src/yplusSwap.sol#L162-L176):
	External calls:
	- [XPLUS.transferFrom(msg.sender,address(this),xplusAmount)](src/yplusSwap.sol#L170)
	State variables written after the call(s):
	- [xplusPoolBalance += xplusAmount](src/yplusSwap.sol#L171)
	[YPlusSwap.xplusPoolBalance](src/yplusSwap.sol#L37) can be used in cross function reentrancies:
	- [YPlusSwap.getYPlusPrice()](src/yplusSwap.sol#L99-L106)
	- [YPlusSwap.xplusPoolBalance](src/yplusSwap.sol#L37)

src/yplusSwap.sol#L162-L176


 - [ ] ID-64
Reentrancy in [Staking._distributeS7Rewards()](src/Staking.sol#L501-L524):
	External calls:
	- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
	State variables written after the call(s):
	- [accumulatedS7Reward = 0](src/Staking.sol#L508)
	[Staking.accumulatedS7Reward](src/Staking.sol#L60) can be used in cross function reentrancies:
	- [Staking.accumulatedS7Reward](src/Staking.sol#L60)

src/Staking.sol#L501-L524


 - [ ] ID-65
Reentrancy in [Staking.manualAllocation()](src/Staking.sol#L712-L733):
	External calls:
	- [_distributeS7Rewards()](src/Staking.sol#L713)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
	- [USDT.transfer(address(yplusSwap),accumulatedYplusFee)](src/Staking.sol#L716)
	- [_swapUsdtForTokens(accumulatedXplusFee,xplusAirdropAddress)](src/Staking.sol#L721)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
	State variables written after the call(s):
	- [accumulatedXplusFee = 0](src/Staking.sol#L722)
	[Staking.accumulatedXplusFee](src/Staking.sol#L59) can be used in cross function reentrancies:
	- [Staking.accumulatedXplusFee](src/Staking.sol#L59)

src/Staking.sol#L712-L733


 - [ ] ID-66
Reentrancy in [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338):
	External calls:
	- [_swapTokensForUSDT(accumulatedMarketingFee,marketingAddress)](src/Token/XPULS.sol#L320)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapTokensForUSDT(accumulatedNodeFee,nodeAddress)](src/Token/XPULS.sol#L325)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapTokensForUSDT(accumulatedProtectionFee,protectionFundAddress)](src/Token/XPULS.sol#L330)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapAndLiquify(accumulatedAddLPFee)](src/Token/XPULS.sol#L335)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
		- [IERC20(USDT).transferFrom(address(distributor),address(this),newBalance)](src/Token/XPULS.sol#L376-L380)
		- [uniswapV2Router.addLiquidity(address(this),USDT,otherHalf,newBalance,0,0,address(0xdead),block.timestamp)](src/Token/XPULS.sol#L383-L392)
	State variables written after the call(s):
	- [accumulatedAddLPFee = 0](src/Token/XPULS.sol#L336)
	[XPLUSToken.accumulatedAddLPFee](src/Token/XPULS.sol#L72) can be used in cross function reentrancies:
	- [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338)
	- [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298)
	- [XPLUSToken.accumulatedAddLPFee](src/Token/XPULS.sol#L72)

src/Token/XPULS.sol#L312-L338


 - [ ] ID-67
Reentrancy in [YPlusSwap.sell(uint256)](src/yplusSwap.sol#L182-L210):
	External calls:
	- [YPLUS.transferFrom(msg.sender,address(this),yplusAmount)](src/yplusSwap.sol#L200)
	- [YPLUS.transfer(0x000000000000000000000000000000000000dEaD,burnTax)](src/yplusSwap.sol#L203)
	- [YPLUS.transfer(marketingAddress,marketingTax)](src/yplusSwap.sol#L204)
	State variables written after the call(s):
	- [xplusPoolBalance -= xplusAmount](src/yplusSwap.sol#L206)
	[YPlusSwap.xplusPoolBalance](src/yplusSwap.sol#L37) can be used in cross function reentrancies:
	- [YPlusSwap.getYPlusPrice()](src/yplusSwap.sol#L99-L106)
	- [YPlusSwap.xplusPoolBalance](src/yplusSwap.sol#L37)

src/yplusSwap.sol#L182-L210


## unused-return
Impact: Medium
Confidence: Medium
 - [ ] ID-68
[Distributor.constructor(address)](src/Token/XPULS.sol#L11-L13) ignores return value by [IERC20(usdt).approve(msg.sender,type()(uint256).max)](src/Token/XPULS.sol#L12)

src/Token/XPULS.sol#L11-L13


 - [ ] ID-69
[Staking.constructor(address,address,address,address,address,address,address)](src/Staking.sol#L103-L142) ignores return value by [USDT.approve(address(router),type()(uint256).max)](src/Staking.sol#L131)

src/Staking.sol#L103-L142


 - [ ] ID-70
[Staking._getPoolUSDTReserve()](src/Staking.sol#L249-L265) ignores return value by [(reserve0,reserve1,None) = pairContract.getReserves()](src/Staking.sol#L255)

src/Staking.sol#L249-L265


 - [ ] ID-71
[YPlusSwap.getXPlusPrice()](src/yplusSwap.sol#L80-L93) ignores return value by [(reserve0,reserve1,None) = pairContract.getReserves()](src/yplusSwap.sol#L85)

src/yplusSwap.sol#L80-L93


 - [ ] ID-72
[Staking.claimReward(uint256)](src/Staking.sol#L308-L353) ignores return value by [router.swapTokensForExactTokens(reward,xplusBefore,path,address(this),block.timestamp)](src/Staking.sol#L328-L334)

src/Staking.sol#L308-L353


 - [ ] ID-73
[Staking._processStakingFunds(uint256,address)](src/Staking.sol#L187-L211) ignores return value by [router.addLiquidity(address(XPLUS),address(USDT),actualXplusAmount,otherHalf,0,0,to,block.timestamp)](src/Staking.sol#L201-L210)

src/Staking.sol#L187-L211


 - [ ] ID-74
[XPLUSToken._swapAndLiquify(uint256)](src/Token/XPULS.sol#L362-L396) ignores return value by [uniswapV2Router.addLiquidity(address(this),USDT,otherHalf,newBalance,0,0,address(0xdead),block.timestamp)](src/Token/XPULS.sol#L383-L392)

src/Token/XPULS.sol#L362-L396


 - [ ] ID-75
[XPLUSToken.constructor(address,address,address,address,address)](src/Token/XPULS.sol#L87-L121) ignores return value by [IERC20(USDT).approve(address(uniswapV2Router),type()(uint256).max)](src/Token/XPULS.sol#L120)

src/Token/XPULS.sol#L87-L121


 - [ ] ID-76
[Staking.withdraw(uint256)](src/Staking.sol#L355-L409) ignores return value by [router.swapTokensForExactTokens(totalReward,xplusBefore,path,address(this),block.timestamp)](src/Staking.sol#L374-L380)

src/Staking.sol#L355-L409


 - [ ] ID-77
[Staking.constructor(address,address,address,address,address,address,address)](src/Staking.sol#L103-L142) ignores return value by [IERC20(_xplus).approve(address(router),type()(uint256).max)](src/Staking.sol#L132)

src/Staking.sol#L103-L142


 - [ ] ID-78
[XPLUSToken.getMyReserves(address)](src/Token/XPULS.sol#L144-L156) ignores return value by [(reserve0,reserve1,None) = IUniswapV2Pair(pair).getReserves()](src/Token/XPULS.sol#L147-L148)

src/Token/XPULS.sol#L144-L156


## shadowing-local
Impact: Low
Confidence: High
 - [ ] ID-79
[NoahNFT.mintBatch(address,string[]).tokenURI](src/NoahNFT.sol#L126) shadows:
	- [ERC721URIStorage.tokenURI(uint256)](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L28-L44) (function)
	- [ERC721.tokenURI(uint256)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L93-L98) (function)
	- [IERC721Metadata.tokenURI(uint256)](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#L26) (function)

src/NoahNFT.sol#L126


 - [ ] ID-80
[NoahNFT.mint(address,string).tokenURI](src/NoahNFT.sol#L93) shadows:
	- [ERC721URIStorage.tokenURI(uint256)](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L28-L44) (function)
	- [ERC721.tokenURI(uint256)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L93-L98) (function)
	- [IERC721Metadata.tokenURI(uint256)](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#L26) (function)

src/NoahNFT.sol#L93


 - [ ] ID-81
[NoahNFT.getOwnedNFTs(address).owner](src/NoahNFT.sol#L220) shadows:
	- [Ownable.owner()](lib/openzeppelin-contracts/contracts/access/Ownable.sol#L43-L45) (function)

src/NoahNFT.sol#L220


## events-maths
Impact: Low
Confidence: Medium
 - [ ] ID-82
[Staking.setSlippageTolerance(uint256)](src/Staking.sol#L825-L828) should emit an event for: 
	- [slippageTolerance = _slippageTolerance](src/Staking.sol#L827) 

src/Staking.sol#L825-L828


 - [ ] ID-83
[XPLUSToken.setSlippageTolerance(uint256)](src/Token/XPULS.sol#L448-L451) should emit an event for: 
	- [slippageTolerance = _slippageTolerance](src/Token/XPULS.sol#L450) 

src/Token/XPULS.sol#L448-L451


 - [ ] ID-84
[Staking.setGlobalRatePerMinute(uint256)](src/Staking.sol#L798-L801) should emit an event for: 
	- [globalRatePerMinute = _rate](src/Staking.sol#L800) 

src/Staking.sol#L798-L801


 - [ ] ID-85
[XPLUSToken.setSwapTokensAtAmount(uint256)](src/Token/XPULS.sol#L444-L446) should emit an event for: 
	- [swapTokensAtAmount = _amount](src/Token/XPULS.sol#L445) 

src/Token/XPULS.sol#L444-L446


 - [ ] ID-86
[XPLUSToken.setTotalProfitTaxRate(uint256)](src/Token/XPULS.sol#L463-L466) should emit an event for: 
	- [totalProfitTaxRate = _rate](src/Token/XPULS.sol#L465) 

src/Token/XPULS.sol#L463-L466


 - [ ] ID-87
[XPLUSToken.setTotalBuyTaxRate(uint256)](src/Token/XPULS.sol#L453-L456) should emit an event for: 
	- [totalBuyTaxRate = _rate](src/Token/XPULS.sol#L455) 

src/Token/XPULS.sol#L453-L456


 - [ ] ID-88
[XPLUSToken.setTotalSellTaxRate(uint256)](src/Token/XPULS.sol#L458-L461) should emit an event for: 
	- [totalSellTaxRate = _rate](src/Token/XPULS.sol#L460) 

src/Token/XPULS.sol#L458-L461


 - [ ] ID-89
[NoahNFT.setMintPrice(uint256)](src/NoahNFT.sol#L65-L67) should emit an event for: 
	- [usdt_30 = price](src/NoahNFT.sol#L66) 

src/NoahNFT.sol#L65-L67


## missing-zero-check
Impact: Low
Confidence: Medium
 - [ ] ID-90
[YPlusSwap.setMarketingAddress(address)._addr](src/yplusSwap.sol#L239) lacks a zero-check on :
		- [marketingAddress = _addr](src/yplusSwap.sol#L240)

src/yplusSwap.sol#L239


 - [ ] ID-91
[XPLUSToken.constructor(address,address,address,address,address)._marketingAddress](src/Token/XPULS.sol#L90) lacks a zero-check on :
		- [marketingAddress = _marketingAddress](src/Token/XPULS.sol#L107)

src/Token/XPULS.sol#L90


 - [ ] ID-92
[XPLUSToken.setProtectionFundAddress(address)._address](src/Token/XPULS.sol#L439) lacks a zero-check on :
		- [protectionFundAddress = _address](src/Token/XPULS.sol#L440)

src/Token/XPULS.sol#L439


 - [ ] ID-93
[Referral.constructor(address).topAddress_](src/Referral.sol#L21) lacks a zero-check on :
		- [topAddress = topAddress_](src/Referral.sol#L22)

src/Referral.sol#L21


 - [ ] ID-94
[XPLUSToken.setYPLUSSwapAddress(address)._address](src/Token/XPULS.sol#L425) lacks a zero-check on :
		- [yplusSwapAddress = _address](src/Token/XPULS.sol#L426)

src/Token/XPULS.sol#L425


 - [ ] ID-95
[XPLUSToken.constructor(address,address,address,address,address)._protectionFundAddress](src/Token/XPULS.sol#L92) lacks a zero-check on :
		- [protectionFundAddress = _protectionFundAddress](src/Token/XPULS.sol#L109)

src/Token/XPULS.sol#L92


 - [ ] ID-96
[Staking.constructor(address,address,address,address,address,address,address)._marketingAddress](src/Staking.sol#L110) lacks a zero-check on :
		- [marketingAddress = _marketingAddress](src/Staking.sol#L125)

src/Staking.sol#L110


 - [ ] ID-97
[NoahNFT.setRewardAddr(address).reward](src/NoahNFT.sol#L61) lacks a zero-check on :
		- [reward_addr = reward](src/NoahNFT.sol#L62)

src/NoahNFT.sol#L61


 - [ ] ID-98
[Staking.constructor(address,address,address,address,address,address,address)._xplusAirdropAddress](src/Staking.sol#L109) lacks a zero-check on :
		- [xplusAirdropAddress = _xplusAirdropAddress](src/Staking.sol#L124)

src/Staking.sol#L109


 - [ ] ID-99
[Staking.setAddresses(address,address)._marketing](src/Staking.sol#L819) lacks a zero-check on :
		- [marketingAddress = _marketing](src/Staking.sol#L822)

src/Staking.sol#L819


 - [ ] ID-100
[YPlusSwap.constructor(address)._marketing](src/yplusSwap.sol#L63) lacks a zero-check on :
		- [marketingAddress = _marketing](src/yplusSwap.sol#L64)

src/yplusSwap.sol#L63


 - [ ] ID-101
[XPLUSToken.constructor(address,address,address,address,address)._nodeAddress](src/Token/XPULS.sol#L91) lacks a zero-check on :
		- [nodeAddress = _nodeAddress](src/Token/XPULS.sol#L108)

src/Token/XPULS.sol#L91


 - [ ] ID-102
[Staking.setAddresses(address,address)._xplusAirdrop](src/Staking.sol#L818) lacks a zero-check on :
		- [xplusAirdropAddress = _xplusAirdrop](src/Staking.sol#L821)

src/Staking.sol#L818


 - [ ] ID-103
[XPLUSToken.setNodeAddress(address)._address](src/Token/XPULS.sol#L434) lacks a zero-check on :
		- [nodeAddress = _address](src/Token/XPULS.sol#L435)

src/Token/XPULS.sol#L434


 - [ ] ID-104
[XPLUSToken.setMarketingAddress(address)._address](src/Token/XPULS.sol#L429) lacks a zero-check on :
		- [marketingAddress = _address](src/Token/XPULS.sol#L430)

src/Token/XPULS.sol#L429


 - [ ] ID-105
[XPLUSToken.setInteractionContract(address)._contract](src/Token/XPULS.sol#L420) lacks a zero-check on :
		- [interactionContract = _contract](src/Token/XPULS.sol#L421)

src/Token/XPULS.sol#L420


## calls-loop
Impact: Low
Confidence: Medium
 - [ ] ID-106
[Staking._distributeGenerationRewards(address,uint256)](src/Staking.sol#L441-L457) has external calls inside a loop: [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
	Calls stack containing the loop:
		Staking.claimReward(uint256)
		Staking._distributeRewards(address,uint256)

src/Staking.sol#L441-L457


 - [ ] ID-107
[Staking._distributeTeamRewards(address,uint256)](src/Staking.sol#L459-L499) has external calls inside a loop: [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
	Calls stack containing the loop:
		Staking.withdraw(uint256)
		Staking._distributeRewards(address,uint256)

src/Staking.sol#L459-L499


 - [ ] ID-108
[Staking._distributeGenerationRewards(address,uint256)](src/Staking.sol#L441-L457) has external calls inside a loop: [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
	Calls stack containing the loop:
		Staking.withdraw(uint256)
		Staking._distributeRewards(address,uint256)

src/Staking.sol#L441-L457


 - [ ] ID-109
[Staking._distributeS7Rewards()](src/Staking.sol#L501-L524) has external calls inside a loop: [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
	Calls stack containing the loop:
		Staking.claimReward(uint256)
		Staking._distributeRewards(address,uint256)
		Staking._distributeTeamRewards(address,uint256)

src/Staking.sol#L501-L524


 - [ ] ID-110
[Staking._distributeTeamRewards(address,uint256)](src/Staking.sol#L459-L499) has external calls inside a loop: [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
	Calls stack containing the loop:
		Staking.claimReward(uint256)
		Staking._distributeRewards(address,uint256)

src/Staking.sol#L459-L499


 - [ ] ID-111
[Staking._distributeS7Rewards()](src/Staking.sol#L501-L524) has external calls inside a loop: [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
	Calls stack containing the loop:
		Staking.claimReward(uint256)
		Staking._distributeRewards(address,uint256)
		Staking._distributeTeamRewards(address,uint256)

src/Staking.sol#L501-L524


 - [ ] ID-112
[Staking._checkAndUpdateLevel(address)](src/Staking.sol#L592-L624) has external calls inside a loop: [yplusSwap.addOneTimeBuyQuota(user,quota)](src/Staking.sol#L609)
	Calls stack containing the loop:
		Staking.stake(uint256,uint256)
		Staking._updatePerformance(address,uint256,bool)

src/Staking.sol#L592-L624


 - [ ] ID-113
[Staking._updateZonePerformance(address)](src/Staking.sol#L576-L590) has external calls inside a loop: [directs = referral.getDirectReferrals(user)](src/Staking.sol#L577)
	Calls stack containing the loop:
		Staking.stake(uint256,uint256)
		Staking._updatePerformance(address,uint256,bool)

src/Staking.sol#L576-L590


 - [ ] ID-114
[Staking._distributeS7Rewards()](src/Staking.sol#L501-L524) has external calls inside a loop: [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
	Calls stack containing the loop:
		Staking.withdraw(uint256)
		Staking._distributeRewards(address,uint256)
		Staking._distributeTeamRewards(address,uint256)

src/Staking.sol#L501-L524


 - [ ] ID-115
[Staking._checkAndUpdateLevel(address)](src/Staking.sol#L592-L624) has external calls inside a loop: [yplusSwap.addOneTimeBuyQuota(user,quota)](src/Staking.sol#L609)
	Calls stack containing the loop:
		Staking.withdraw(uint256)
		Staking._updatePerformance(address,uint256,bool)

src/Staking.sol#L592-L624


 - [ ] ID-116
[Staking._distributeS7Rewards()](src/Staking.sol#L501-L524) has external calls inside a loop: [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
	Calls stack containing the loop:
		Staking.manualAllocation()

src/Staking.sol#L501-L524


 - [ ] ID-117
[ERC721._checkOnERC721Received(address,address,uint256,bytes)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L399-L421) has external calls inside a loop: [retval = IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L406-L417)
	Calls stack containing the loop:
		NoahNFT.mintBatch(address,string[])
		ERC721._safeMint(address,uint256)
		ERC721._safeMint(address,uint256,bytes)

lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L399-L421


 - [ ] ID-118
[Staking._checkAndUpdateLevel(address)](src/Staking.sol#L592-L624) has external calls inside a loop: [yplusSwap.addOneTimeBuyQuota(user,quota)](src/Staking.sol#L609)
	Calls stack containing the loop:
		Staking.updateLevel(address)

src/Staking.sol#L592-L624


 - [ ] ID-119
[Staking._distributeS7Rewards()](src/Staking.sol#L501-L524) has external calls inside a loop: [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
	Calls stack containing the loop:
		Staking.withdraw(uint256)
		Staking._distributeRewards(address,uint256)
		Staking._distributeTeamRewards(address,uint256)

src/Staking.sol#L501-L524


 - [ ] ID-120
[Staking._updateZonePerformance(address)](src/Staking.sol#L576-L590) has external calls inside a loop: [directs = referral.getDirectReferrals(user)](src/Staking.sol#L577)
	Calls stack containing the loop:
		Staking.withdraw(uint256)
		Staking._updatePerformance(address,uint256,bool)

src/Staking.sol#L576-L590


## reentrancy-benign
Impact: Low
Confidence: Medium
 - [ ] ID-121
Reentrancy in [NoahNFT.mintBatch(address,string[])](src/NoahNFT.sol#L117-L145):
	External calls:
	- [usdtToken.safeTransferFrom(msg.sender,address(this),totalPrice)](src/NoahNFT.sol#L123)
	- [_safeMint(to,nextTokenId)](src/NoahNFT.sol#L128)
		- [retval = IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L406-L417)
	State variables written after the call(s):
	- [_addTokenToOwnerEnumeration(to,nextTokenId)](src/NoahNFT.sol#L132)
		- [_ownedTokensIndex[tokenId] = _ownedTokens[to].length](src/NoahNFT.sol#L225)
	- [_setTokenURI(nextTokenId,tokenURI)](src/NoahNFT.sol#L129)
		- [_tokenURIs[tokenId] = _tokenURI](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L57)
	- [mintRecords[nextTokenId] = MintRecord({mintedBy:msg.sender,mintedTime:block.timestamp,tokenURI:tokenURI,blockNum:block.number})](src/NoahNFT.sol#L134-L139)
	- [mintedURIs[tokenURI] = true](src/NoahNFT.sol#L131)

src/NoahNFT.sol#L117-L145


 - [ ] ID-122
Reentrancy in [NoahNFT.mint(address,string)](src/NoahNFT.sol#L93-L115):
	External calls:
	- [usdtToken.safeTransferFrom(msg.sender,address(this),usdt_30)](src/NoahNFT.sol#L97)
	- [_safeMint(to,nextTokenId)](src/NoahNFT.sol#L99)
		- [retval = IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L406-L417)
	State variables written after the call(s):
	- [_addTokenToOwnerEnumeration(to,nextTokenId)](src/NoahNFT.sol#L103)
		- [_ownedTokens[to].push(tokenId)](src/NoahNFT.sol#L226)
	- [_addTokenToOwnerEnumeration(to,nextTokenId)](src/NoahNFT.sol#L103)
		- [_ownedTokensIndex[tokenId] = _ownedTokens[to].length](src/NoahNFT.sol#L225)
	- [_setTokenURI(nextTokenId,tokenURI)](src/NoahNFT.sol#L100)
		- [_tokenURIs[tokenId] = _tokenURI](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L57)
	- [mintRecords[nextTokenId] = MintRecord({mintedBy:msg.sender,mintedTime:block.timestamp,tokenURI:tokenURI,blockNum:block.number})](src/NoahNFT.sol#L105-L110)
	- [mintedTokenIds.push(nextTokenId)](src/NoahNFT.sol#L112)
	- [mintedURIs[tokenURI] = true](src/NoahNFT.sol#L102)
	- [userMintedTokenIds[msg.sender].push(nextTokenId)](src/NoahNFT.sol#L113)

src/NoahNFT.sol#L93-L115


 - [ ] ID-123
Reentrancy in [Staking._checkAndUpdateLevel(address)](src/Staking.sol#L592-L624):
	External calls:
	- [yplusSwap.addOneTimeBuyQuota(user,quota)](src/Staking.sol#L609)
	State variables written after the call(s):
	- [_addS7User(user)](src/Staking.sol#L617)
		- [isS7User[user] = true](src/Staking.sol#L639)
	- [_removeS7User(user)](src/Staking.sol#L619)
		- [delete isS7User[user]](src/Staking.sol#L656)
	- [_addS7User(user)](src/Staking.sol#L617)
		- [s7UserIndex[user] = s7Users.length](src/Staking.sol#L637)
	- [_removeS7User(user)](src/Staking.sol#L619)
		- [s7UserIndex[lastUser] = index](src/Staking.sol#L652)
		- [delete s7UserIndex[user]](src/Staking.sol#L657)
	- [_addS7User(user)](src/Staking.sol#L617)
		- [s7Users.push(user)](src/Staking.sol#L638)
	- [_removeS7User(user)](src/Staking.sol#L619)
		- [s7Users[index] = lastUser](src/Staking.sol#L651)
		- [s7Users.pop()](src/Staking.sol#L655)

src/Staking.sol#L592-L624


 - [ ] ID-124
Reentrancy in [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298):
	External calls:
	- [_swapAndDistribute()](src/Token/XPULS.sol#L232)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
		- [IERC20(USDT).transferFrom(address(distributor),address(this),newBalance)](src/Token/XPULS.sol#L376-L380)
		- [uniswapV2Router.addLiquidity(address(this),USDT,otherHalf,newBalance,0,0,address(0xdead),block.timestamp)](src/Token/XPULS.sol#L383-L392)
	State variables written after the call(s):
	- [tOwnedU[sender] = tOwnedU[sender] - amountUOut](src/Token/XPULS.sol#L259)
	- [tOwnedU[sender] = 0](src/Token/XPULS.sol#L267)
	- [tOwnedU[sender] = 0](src/Token/XPULS.sol#L271)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-125
Reentrancy in [Staking._distributeRewards(address,uint256)](src/Staking.sol#L418-L439):
	External calls:
	- [_distributeGenerationRewards(user,generationReward)](src/Staking.sol#L420)
		- [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
		- [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)
	- [_distributeTeamRewards(user,teamReward)](src/Staking.sol#L423)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
		- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
		- [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)
	State variables written after the call(s):
	- [accumulatedYplusFee += yplusFee](src/Staking.sol#L426)

src/Staking.sol#L418-L439


 - [ ] ID-126
Reentrancy in [Node.transferNode(uint256,address)](src/Node.sol#L142-L175):
	External calls:
	- [USDT.transfer(msg.sender,reward)](src/Node.sol#L155)
	State variables written after the call(s):
	- [userNodeIndices[newOwner].push(index)](src/Node.sol#L171)

src/Node.sol#L142-L175


 - [ ] ID-127
Reentrancy in [Staking._distributeRewards(address,uint256)](src/Staking.sol#L418-L439):
	External calls:
	- [_distributeGenerationRewards(user,generationReward)](src/Staking.sol#L420)
		- [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
		- [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)
	- [_distributeTeamRewards(user,teamReward)](src/Staking.sol#L423)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
		- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
		- [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)
	- [_swapUsdtForTokens(accumulatedYplusFee,address(yplusSwap))](src/Staking.sol#L429)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
	State variables written after the call(s):
	- [accumulatedXplusFee += xplusFee](src/Staking.sol#L434)

src/Staking.sol#L418-L439


 - [ ] ID-128
Reentrancy in [Staking.withdraw(uint256)](src/Staking.sol#L355-L409):
	External calls:
	- [router.swapTokensForExactTokens(totalReward,xplusBefore,path,address(this),block.timestamp)](src/Staking.sol#L374-L380)
	- [_distributeRewards(msg.sender,distributePortion)](src/Staking.sol#L391)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
		- [USDT.transfer(marketingAddress,accumulatedS7Reward)](src/Staking.sol#L507)
		- [USDT.transfer(upline[i],rewardPerGen)](src/Staking.sol#L449)
		- [USDT.transfer(marketingAddress,totalAmount - distributed)](src/Staking.sol#L455)
		- [USDT.transfer(s7Users[i],rewardPerUser)](src/Staking.sol#L516)
		- [USDT.transfer(upline[i],reward)](src/Staking.sol#L482)
		- [USDT.transfer(marketingAddress,totalAmount - distributedAmount)](src/Staking.sol#L497)
	- [USDT.transfer(msg.sender,principal + actualReward)](src/Staking.sol#L394)
	- [XPLUS.recycleLiquidity(xplusUsed)](src/Staking.sol#L396)
	State variables written after the call(s):
	- [userTotalStaked[msg.sender] -= principal](src/Staking.sol#L402)

src/Staking.sol#L355-L409


 - [ ] ID-129
Reentrancy in [Staking.stake(uint256,uint256)](src/Staking.sol#L144-L185):
	External calls:
	- [USDT.transferFrom(msg.sender,address(this),amount)](src/Staking.sol#L152)
	- [_processStakingFunds(amount,address(0xdead))](src/Staking.sol#L154)
		- [router.swapExactTokensForTokensSupportingFeeOnTransferTokens(usdtAmount,minOutput,path,to,block.timestamp)](src/Staking.sol#L534-L540)
		- [router.addLiquidity(address(XPLUS),address(USDT),actualXplusAmount,otherHalf,0,0,to,block.timestamp)](src/Staking.sol#L201-L210)
	State variables written after the call(s):
	- [userOrders[msg.sender].push(StakingOrder({planId:planId,amount:amount,startTime:startTime,endTime:endTime,lastClaimTime:startTime,claimedReward:0,isWithdrawn:false}))](src/Staking.sol#L160-L168)
	- [userTotalStaked[msg.sender] += amount](src/Staking.sol#L172)

src/Staking.sol#L144-L185


## reentrancy-events
Impact: Low
Confidence: Medium
 - [ ] ID-130
Reentrancy in [XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298):
	External calls:
	- [_swapAndDistribute()](src/Token/XPULS.sol#L232)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
		- [IERC20(USDT).transferFrom(address(distributor),address(this),newBalance)](src/Token/XPULS.sol#L376-L380)
		- [uniswapV2Router.addLiquidity(address(this),USDT,otherHalf,newBalance,0,0,address(0xdead),block.timestamp)](src/Token/XPULS.sol#L383-L392)
	Event emitted after the call(s):
	- [Transfer(from,to,amount)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L237)
		- [super._transfer(sender,address(this),profitTax)](src/Token/XPULS.sol#L275)
	- [Transfer(from,to,amount)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L237)
		- [super._transfer(sender,recipient,amount - baseSellTax - profitTax)](src/Token/XPULS.sol#L290-L294)
	- [Transfer(from,to,amount)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L237)
		- [super._transfer(sender,address(this),marketingFee + nodeFee)](src/Token/XPULS.sol#L244)
	- [Transfer(from,to,amount)](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L237)
		- [super._transfer(sender,address(0xdead),burnFee)](src/Token/XPULS.sol#L243)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-131
Reentrancy in [Staking._checkAndUpdateLevel(address)](src/Staking.sol#L592-L624):
	External calls:
	- [yplusSwap.addOneTimeBuyQuota(user,quota)](src/Staking.sol#L609)
	Event emitted after the call(s):
	- [LevelUpdated(user,oldLevel,newLevel)](src/Staking.sol#L622)
	- [S7UserAdded(user)](src/Staking.sol#L640)
		- [_addS7User(user)](src/Staking.sol#L617)
	- [S7UserRemoved(user)](src/Staking.sol#L659)
		- [_removeS7User(user)](src/Staking.sol#L619)

src/Staking.sol#L592-L624


 - [ ] ID-132
Reentrancy in [XPLUSToken._swapAndLiquify(uint256)](src/Token/XPULS.sol#L362-L396):
	External calls:
	- [_swapTokensForUSDT(half,address(distributor))](src/Token/XPULS.sol#L368)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [IERC20(USDT).transferFrom(address(distributor),address(this),newBalance)](src/Token/XPULS.sol#L376-L380)
	- [uniswapV2Router.addLiquidity(address(this),USDT,otherHalf,newBalance,0,0,address(0xdead),block.timestamp)](src/Token/XPULS.sol#L383-L392)
	Event emitted after the call(s):
	- [SwapAndLiquify(half,newBalance,otherHalf)](src/Token/XPULS.sol#L394)

src/Token/XPULS.sol#L362-L396


 - [ ] ID-133
Reentrancy in [XPLUSToken._swapAndDistribute()](src/Token/XPULS.sol#L312-L338):
	External calls:
	- [_swapTokensForUSDT(accumulatedMarketingFee,marketingAddress)](src/Token/XPULS.sol#L320)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapTokensForUSDT(accumulatedNodeFee,nodeAddress)](src/Token/XPULS.sol#L325)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapTokensForUSDT(accumulatedProtectionFee,protectionFundAddress)](src/Token/XPULS.sol#L330)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
	- [_swapAndLiquify(accumulatedAddLPFee)](src/Token/XPULS.sol#L335)
		- [uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,minOutput,path,to,block.timestamp)](src/Token/XPULS.sol#L353-L359)
		- [IERC20(USDT).transferFrom(address(distributor),address(this),newBalance)](src/Token/XPULS.sol#L376-L380)
		- [uniswapV2Router.addLiquidity(address(this),USDT,otherHalf,newBalance,0,0,address(0xdead),block.timestamp)](src/Token/XPULS.sol#L383-L392)
	Event emitted after the call(s):
	- [SwapAndLiquify(half,newBalance,otherHalf)](src/Token/XPULS.sol#L394)
		- [_swapAndLiquify(accumulatedAddLPFee)](src/Token/XPULS.sol#L335)

src/Token/XPULS.sol#L312-L338


 - [ ] ID-134
Reentrancy in [NoahNFT.mint(address,string)](src/NoahNFT.sol#L93-L115):
	External calls:
	- [usdtToken.safeTransferFrom(msg.sender,address(this),usdt_30)](src/NoahNFT.sol#L97)
	- [_safeMint(to,nextTokenId)](src/NoahNFT.sol#L99)
		- [retval = IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L406-L417)
	Event emitted after the call(s):
	- [MetadataUpdate(tokenId)](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L59)
		- [_setTokenURI(nextTokenId,tokenURI)](src/NoahNFT.sol#L100)
	- [Transfer(address(0),to,tokenId)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L283)
		- [_safeMint(to,nextTokenId)](src/NoahNFT.sol#L99)

src/NoahNFT.sol#L93-L115


 - [ ] ID-135
Reentrancy in [NoahNFT.mintBatch(address,string[])](src/NoahNFT.sol#L117-L145):
	External calls:
	- [usdtToken.safeTransferFrom(msg.sender,address(this),totalPrice)](src/NoahNFT.sol#L123)
	- [_safeMint(to,nextTokenId)](src/NoahNFT.sol#L128)
		- [retval = IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L406-L417)
	Event emitted after the call(s):
	- [MetadataUpdate(tokenId)](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L59)
		- [_setTokenURI(nextTokenId,tokenURI)](src/NoahNFT.sol#L129)
	- [Transfer(address(0),to,tokenId)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L283)
		- [_safeMint(to,nextTokenId)](src/NoahNFT.sol#L128)

src/NoahNFT.sol#L117-L145


## timestamp
Impact: Low
Confidence: Medium
 - [ ] ID-136
[Node.claimNodeReward(uint256)](src/Node.sol#L79-L99) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(index < nodes.length,Invalid node)](src/Node.sol#L80)
	- [require(bool,string)(msg.sender == node.owner,Not node owner)](src/Node.sol#L82)
	- [require(bool,string)(node.isActive,Node not active)](src/Node.sol#L83)

src/Node.sol#L79-L99


 - [ ] ID-137
[Staking.claimReward(uint256)](src/Staking.sol#L308-L353) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(orderId < userOrders[msg.sender].length,Invalid order)](src/Staking.sol#L309)
	- [require(bool,string)(! order.isWithdrawn,Already withdrawn)](src/Staking.sol#L311)
	- [require(bool,string)(reward > 0,No reward to claim)](src/Staking.sol#L314)

src/Staking.sol#L308-L353


 - [ ] ID-138
[Node.transferNode(uint256,address)](src/Node.sol#L142-L175) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(index < nodes.length,Invalid node)](src/Node.sol#L143)
	- [require(bool,string)(node.owner == msg.sender,Not node owner)](src/Node.sol#L145)

src/Node.sol#L142-L175


 - [ ] ID-139
[NoahNFT.getStakedNFTInfo(uint256)](src/NoahNFT.sol#L211-L214) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(stakeId < stakedNFTsArray.length,Invalid stake ID)](src/NoahNFT.sol#L212)

src/NoahNFT.sol#L211-L214


 - [ ] ID-140
[Node.setNodeActive(uint256,bool)](src/Node.sol#L135-L138) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(index < nodes.length,Invalid node)](src/Node.sol#L136)

src/Node.sol#L135-L138


 - [ ] ID-141
[Staking._checkTurboMechanism(address,uint256)](src/Staking.sol#L411-L416) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(totalWithdrawn <= totalBuyAmount,Exceeds turbo limit: XPLUS buy amount insufficient)](src/Staking.sol#L415)

src/Staking.sol#L411-L416


 - [ ] ID-142
[Node.pendingReward(uint256)](src/Node.sol#L65-L74) uses timestamp for comparisons
	Dangerous comparisons:
	- [index >= nodes.length](src/Node.sol#L66)

src/Node.sol#L65-L74


 - [ ] ID-143
[XPLUSToken.updatePoolReserve()](src/Token/XPULS.sol#L129-L135) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp >= poolStatus.t + 3600](src/Token/XPULS.sol#L130)

src/Token/XPULS.sol#L129-L135


 - [ ] ID-144
[Staking._powu(uint256,uint256)](src/Staking.sol#L292-L301) uses timestamp for comparisons
	Dangerous comparisons:
	- [exp > 0](src/Staking.sol#L294)
	- [exp & 1 != 0](src/Staking.sol#L295)

src/Staking.sol#L292-L301


 - [ ] ID-145
[Staking.getUserStats(address)](src/Staking.sol#L739-L756) uses timestamp for comparisons
	Dangerous comparisons:
	- [i < userOrders[user].length](src/Staking.sol#L749)

src/Staking.sol#L739-L756


 - [ ] ID-146
[XPLUSToken.updatePoolReserve(uint112)](src/Token/XPULS.sol#L137-L142) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp >= poolStatus.t + 3600](src/Token/XPULS.sol#L138)

src/Token/XPULS.sol#L137-L142


 - [ ] ID-147
[Staking.withdraw(uint256)](src/Staking.sol#L355-L409) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(orderId < userOrders[msg.sender].length,Invalid order)](src/Staking.sol#L356)
	- [require(bool,string)(! order.isWithdrawn,Already withdrawn)](src/Staking.sol#L358)
	- [require(bool,string)(block.timestamp >= order.endTime,Not expired yet)](src/Staking.sol#L359)

src/Staking.sol#L355-L409


 - [ ] ID-148
[Staking.calculateReward(address,uint256)](src/Staking.sol#L267-L290) uses timestamp for comparisons
	Dangerous comparisons:
	- [timeElapsed == 0](src/Staking.sol#L276)
	- [timeElapsed > maxElapsedTime](src/Staking.sol#L283)
	- [totalAmount > principal](src/Staking.sol#L289)

src/Staking.sol#L267-L290


 - [ ] ID-149
[FirstLaunch.launch()](src/Token/XPULS.sol#L19-L22) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(launchedAtTimestamp == 0,Already launched)](src/Token/XPULS.sol#L20)

src/Token/XPULS.sol#L19-L22


 - [ ] ID-150
[Staking._checkGlobalLimit(uint256)](src/Staking.sol#L235-L247) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(used + amount <= maxPerMinute,Exceeds global limit)](src/Staking.sol#L244)

src/Staking.sol#L235-L247


 - [ ] ID-151
[YPlusSwap.buyWithDailyQuota(uint256)](src/yplusSwap.sol#L123-L142) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp >= lastQuotaResetTime[msg.sender] + QUOTA_RESET_TIME](src/yplusSwap.sol#L131)

src/yplusSwap.sol#L123-L142


 - [ ] ID-152
[XPLUSToken._transfer(address,address,uint256)](src/Token/XPULS.sol#L182-L298) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(block.timestamp >= lastBuyTime[sender] + coldTime,cold)](src/Token/XPULS.sol#L219)

src/Token/XPULS.sol#L182-L298


 - [ ] ID-153
[Staking._getGlobalLimitData()](src/Staking.sol#L213-L233) uses timestamp for comparisons
	Dangerous comparisons:
	- [windowReset = block.timestamp >= lastGlobalStakeTime + 60](src/Staking.sol#L222)

src/Staking.sol#L213-L233


## assembly
Impact: Informational
Confidence: High
 - [ ] ID-154
[Address._revert(bytes,string)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L231-L243) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Address.sol#L236-L239)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L231-L243


 - [ ] ID-155
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L62-L66)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L85-L92)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L99-L108)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L55-L134


 - [ ] ID-156
[Referral.getReferrals(address,uint256)](src/Referral.sol#L60-L73) uses assembly
	- [INLINE ASM](src/Referral.sol#L70)

src/Referral.sol#L60-L73


 - [ ] ID-157
[Strings.toString(uint256)](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L19-L39) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L25-L27)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L31-L33)

lib/openzeppelin-contracts/contracts/utils/Strings.sol#L19-L39


 - [ ] ID-158
[ERC721._checkOnERC721Received(address,address,uint256,bytes)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L399-L421) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L413-L415)

lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L399-L421


## pragma
Impact: Informational
Confidence: High
 - [ ] ID-159
4 different versions of Solidity are used:
	- Version constraint ^0.8.0 is used by:
		-[^0.8.0](lib/openzeppelin-contracts/contracts/access/Ownable.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/interfaces/IERC4906.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/utils/Context.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L4)
		-[^0.8.0](lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#L4)
		-[^0.8.0](src/interfaces/IReferral.sol#L2)
		-[^0.8.0](src/interfaces/IUniswap.sol#L2)
		-[^0.8.0](src/interfaces/IXPLUSToken.sol#L2)
		-[^0.8.0](src/interfaces/IYPLUSSwap.sol#L2)
	- Version constraint ^0.8.1 is used by:
		-[^0.8.1](lib/openzeppelin-contracts/contracts/utils/Address.sol#L4)
	- Version constraint ^0.8.20 is used by:
		-[^0.8.20](src/NoahNFT.sol#L2)
	- Version constraint ^0.8.28 is used by:
		-[^0.8.28](src/Node.sol#L2)
		-[^0.8.28](src/Referral.sol#L2)
		-[^0.8.28](src/Staking.sol#L2)
		-[^0.8.28](src/Token/XPULS.sol#L2)
		-[^0.8.28](src/Token/YPULS.sol#L2)
		-[^0.8.28](src/yplusSwap.sol#L2)

lib/openzeppelin-contracts/contracts/access/Ownable.sol#L4


## costly-loop
Impact: Informational
Confidence: Medium
 - [ ] ID-160
[ERC721._transfer(address,address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L333-L359) has costly operations inside a loop:
	- [delete _tokenApprovals[tokenId]](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L343)
	Calls stack containing the loop:
		NoahNFT.stakeNFTs(uint256[])
		NoahNFT.transferFrom(address,address,uint256)
		ERC721.transferFrom(address,address,uint256)

lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L333-L359


 - [ ] ID-161
[Node.addNode(address)](src/Node.sol#L103-L122) has costly operations inside a loop:
	- [nodeCount ++](src/Node.sol#L119)
	Calls stack containing the loop:
		Node.batchAddNodes(address[])

src/Node.sol#L103-L122


 - [ ] ID-162
[NoahNFT.mintBatch(address,string[])](src/NoahNFT.sol#L117-L145) has costly operations inside a loop:
	- [nextTokenId ++](src/NoahNFT.sol#L143)

src/NoahNFT.sol#L117-L145


 - [ ] ID-163
[NoahNFT._removeTokenFromOwnerEnumeration(address,uint256)](src/NoahNFT.sol#L229-L241) has costly operations inside a loop:
	- [delete _ownedTokensIndex[tokenId]](src/NoahNFT.sol#L240)
	Calls stack containing the loop:
		NoahNFT.stakeNFTs(uint256[])
		NoahNFT.transferFrom(address,address,uint256)

src/NoahNFT.sol#L229-L241


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-164
Version constraint ^0.8.20 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- VerbatimInvalidDeduplication
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess.
It is used by:
	- [^0.8.20](src/NoahNFT.sol#L2)

src/NoahNFT.sol#L2


 - [ ] ID-165
Version constraint ^0.8.1 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess
	- AbiReencodingHeadOverflowWithStaticArrayCleanup
	- DirtyBytesArrayToStorage
	- DataLocationChangeInInternalOverride
	- NestedCalldataArrayAbiReencodingSizeValidation
	- SignedImmutables
	- ABIDecodeTwoDimensionalArrayMemory
	- KeccakCaching.
It is used by:
	- [^0.8.1](lib/openzeppelin-contracts/contracts/utils/Address.sol#L4)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L4


 - [ ] ID-166
Version constraint ^0.8.0 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess
	- AbiReencodingHeadOverflowWithStaticArrayCleanup
	- DirtyBytesArrayToStorage
	- DataLocationChangeInInternalOverride
	- NestedCalldataArrayAbiReencodingSizeValidation
	- SignedImmutables
	- ABIDecodeTwoDimensionalArrayMemory
	- KeccakCaching.
It is used by:
	- [^0.8.0](lib/openzeppelin-contracts/contracts/access/Ownable.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/interfaces/IERC4906.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/utils/Context.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L4)
	- [^0.8.0](lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#L4)
	- [^0.8.0](src/interfaces/IReferral.sol#L2)
	- [^0.8.0](src/interfaces/IUniswap.sol#L2)
	- [^0.8.0](src/interfaces/IXPLUSToken.sol#L2)
	- [^0.8.0](src/interfaces/IYPLUSSwap.sol#L2)

lib/openzeppelin-contracts/contracts/access/Ownable.sol#L4


## low-level-calls
Impact: Informational
Confidence: High
 - [ ] ID-167
Low level call in [Address.functionCallWithValue(address,bytes,uint256,string)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L128-L137):
	- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L135)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L128-L137


 - [ ] ID-168
Low level call in [Address.sendValue(address,uint256)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L64-L69):
	- [(success,None) = recipient.call{value: amount}()](lib/openzeppelin-contracts/contracts/utils/Address.sol#L67)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L64-L69


 - [ ] ID-169
Low level call in [Address.functionStaticCall(address,bytes,string)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L155-L162):
	- [(success,returndata) = target.staticcall(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L160)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L155-L162


 - [ ] ID-170
Low level call in [SafeERC20._callOptionalReturnBool(IERC20,bytes)](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L134-L142):
	- [(success,returndata) = address(token).call(data)](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L139)

lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L134-L142


 - [ ] ID-171
Low level call in [XPLUSToken.emergencyWithdraw(address,uint256)](src/Token/XPULS.sol#L486-L496):
	- [(success,None) = address(owner()).call{value: amount}()](src/Token/XPULS.sol#L491)

src/Token/XPULS.sol#L486-L496


 - [ ] ID-172
Low level call in [Address.functionDelegateCall(address,bytes,string)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L180-L187):
	- [(success,returndata) = target.delegatecall(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L185)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L180-L187


## missing-inheritance
Impact: Informational
Confidence: High
 - [ ] ID-173
[YPlusSwap](src/yplusSwap.sol#L22-L261) should inherit from [IYPLUSSwap](src/interfaces/IYPLUSSwap.sol#L4-L7)

src/yplusSwap.sol#L22-L261


## naming-convention
Impact: Informational
Confidence: High
 - [ ] ID-174
Function [NoahNFT.GetUSDTReward(address,uint256)](src/NoahNFT.sol#L75-L79) is not in mixedCase

src/NoahNFT.sol#L75-L79


 - [ ] ID-175
Parameter [Staking.setYPLUSSwap(address)._yplusSwap](src/Staking.sol#L790) is not in mixedCase

src/Staking.sol#L790


 - [ ] ID-176
Parameter [XPLUSToken.setTotalBuyTaxRate(uint256)._rate](src/Token/XPULS.sol#L453) is not in mixedCase

src/Token/XPULS.sol#L453


 - [ ] ID-177
Parameter [XPLUSToken.setProtectionFundAddress(address)._address](src/Token/XPULS.sol#L439) is not in mixedCase

src/Token/XPULS.sol#L439


 - [ ] ID-178
Parameter [Staking.setSlippageTolerance(uint256)._slippageTolerance](src/Staking.sol#L825) is not in mixedCase

src/Staking.sol#L825


 - [ ] ID-179
Parameter [XPLUSToken.setSwapTokensAtAmount(uint256)._amount](src/Token/XPULS.sol#L444) is not in mixedCase

src/Token/XPULS.sol#L444


 - [ ] ID-180
Parameter [Staking.setMaxStakePerTx(uint256)._max](src/Staking.sol#L794) is not in mixedCase

src/Staking.sol#L794


 - [ ] ID-181
Variable [NoahNFT.reward_addr](src/NoahNFT.sol#L18) is not in mixedCase

src/NoahNFT.sol#L18


 - [ ] ID-182
Variable [Staking.XPLUS](src/Staking.sol#L37) is not in mixedCase

src/Staking.sol#L37


 - [ ] ID-183
Variable [XPLUSToken.USDT](src/Token/XPULS.sol#L40) is not in mixedCase

src/Token/XPULS.sol#L40


 - [ ] ID-184
Parameter [XPLUSToken.setInteractionContract(address)._contract](src/Token/XPULS.sol#L420) is not in mixedCase

src/Token/XPULS.sol#L420


 - [ ] ID-185
Variable [NoahNFT.usdt_30](src/NoahNFT.sol#L20) is not in mixedCase

src/NoahNFT.sol#L20


 - [ ] ID-186
Parameter [XPLUSToken.setTotalSellTaxRate(uint256)._rate](src/Token/XPULS.sol#L458) is not in mixedCase

src/Token/XPULS.sol#L458


 - [ ] ID-187
Function [IUniswapV2Router02.WETH()](src/interfaces/IUniswap.sol#L18) is not in mixedCase

src/interfaces/IUniswap.sol#L18


 - [ ] ID-188
Parameter [YPlusSwap.setMarketingAddress(address)._addr](src/yplusSwap.sol#L239) is not in mixedCase

src/yplusSwap.sol#L239


 - [ ] ID-189
Parameter [XPLUSToken.setTotalProfitTaxRate(uint256)._rate](src/Token/XPULS.sol#L463) is not in mixedCase

src/Token/XPULS.sol#L463


 - [ ] ID-190
Parameter [Staking.setDailyQuotaRate(uint256)._rate](src/Staking.sol#L803) is not in mixedCase

src/Staking.sol#L803


 - [ ] ID-191
Function [IERC20Permit.DOMAIN_SEPARATOR()](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L89) is not in mixedCase

lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L89


 - [ ] ID-192
Parameter [XPLUSToken.setMarketingAddress(address)._address](src/Token/XPULS.sol#L429) is not in mixedCase

src/Token/XPULS.sol#L429


 - [ ] ID-193
Parameter [Staking.setAddresses(address,address)._marketing](src/Staking.sol#L819) is not in mixedCase

src/Staking.sol#L819


 - [ ] ID-194
Parameter [Staking.setReferral(address)._referral](src/Staking.sol#L786) is not in mixedCase

src/Staking.sol#L786


 - [ ] ID-195
Parameter [XPLUSToken.setYPLUSSwapAddress(address)._address](src/Token/XPULS.sol#L425) is not in mixedCase

src/Token/XPULS.sol#L425


 - [ ] ID-196
Parameter [XPLUSToken.setNodeAddress(address)._address](src/Token/XPULS.sol#L434) is not in mixedCase

src/Token/XPULS.sol#L434


 - [ ] ID-197
Parameter [XPLUSToken.setSlippageTolerance(uint256)._slippageTolerance](src/Token/XPULS.sol#L448) is not in mixedCase

src/Token/XPULS.sol#L448


 - [ ] ID-198
Function [ERC721.__unsafe_increaseBalance(address,uint256)](lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L463-L465) is not in mixedCase

lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#L463-L465


 - [ ] ID-199
Parameter [Referral.bind(address)._referrer](src/Referral.sol#L27) is not in mixedCase

src/Referral.sol#L27


 - [ ] ID-200
Parameter [Staking.setAddresses(address,address)._xplusAirdrop](src/Staking.sol#L818) is not in mixedCase

src/Staking.sol#L818


 - [ ] ID-201
Parameter [Staking.setGlobalRatePerMinute(uint256)._rate](src/Staking.sol#L798) is not in mixedCase

src/Staking.sol#L798


 - [ ] ID-202
Variable [Staking.USDT](src/Staking.sol#L36) is not in mixedCase

src/Staking.sol#L36


## too-many-digits
Impact: Informational
Confidence: Medium
 - [ ] ID-203
[Staking.setDailyQuotaRate(uint256)](src/Staking.sol#L803-L806) uses literals with too many digits:
	- [require(bool,string)(_rate >= 100 && _rate <= 100000,Rate must be 100-100000)](src/Staking.sol#L804)

src/Staking.sol#L803-L806


## constable-states
Impact: Optimization
Confidence: High
 - [ ] ID-204
[XPLUSToken.coldTime](src/Token/XPULS.sol#L47) should be constant 

src/Token/XPULS.sol#L47


 - [ ] ID-205
[NoahNFT.blackHole](src/NoahNFT.sol#L19) should be constant 

src/NoahNFT.sol#L19


## immutable-states
Impact: Optimization
Confidence: High
 - [ ] ID-206
[XPLUSToken.uniswapV2Pair](src/Token/XPULS.sol#L41) should be immutable 

src/Token/XPULS.sol#L41


