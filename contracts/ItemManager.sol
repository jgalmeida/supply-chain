pragma solidity 0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./Item.sol";

contract ItemManager is Ownable {
    enum SupplyChainState {
        Created,
        Paid,
        Delivered
    }

    struct SupplyChainItem {
        string identifier;
        SupplyChainState state;
        Item item;
    }

    mapping(uint256 => SupplyChainItem) public items;
    uint256 itemIndex;

    event SupplyChainStep(
        uint256 _itemIndex,
        SupplyChainState _step,
        address _itemAddress
    );

    function createItem(string memory _identifier, uint256 _itemPrice)
        public
        onlyOwner
    {
        Item item = new Item(this, _itemPrice, itemIndex);

        items[itemIndex].item = item;
        items[itemIndex].identifier = _identifier;
        items[itemIndex].state = SupplyChainState.Created;

        emit SupplyChainStep(
            itemIndex,
            SupplyChainState.Created,
            address(item)
        );

        itemIndex++;
    }

    function triggerPayment(uint256 _itemIndex) public payable {
        require(
            items[_itemIndex].state == SupplyChainState.Created,
            "Item is further in supply chain"
        );

        items[_itemIndex].state = SupplyChainState.Paid;

        emit SupplyChainStep(
            _itemIndex,
            SupplyChainState.Paid,
            address(items[_itemIndex].item)
        );
    }

    function triggerDelivery(uint256 _itemIndex) public onlyOwner {
        require(
            items[_itemIndex].state == SupplyChainState.Paid,
            "Item is further in supply chain"
        );

        items[_itemIndex].state = SupplyChainState.Delivered;

        emit SupplyChainStep(
            itemIndex,
            SupplyChainState.Delivered,
            address(items[_itemIndex].item)
        );
    }
}
