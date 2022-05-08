// React
import React, { Component } from 'react';
import PropTypes from 'prop-types';

class OrdersList extends Component {
  static propTypes = {
    orderItems: PropTypes.array.isRequired
  };

  render() {
    return (
      <table className="table table-hover orders-table">
        <tbody>
          {this.props.orderItems.map(orderItem => {
            return <tr key={orderItem.id}>
              <td>{orderItem.productName}</td>
              <td>
                <p> print currency </p>
              </td>
            </tr>
          })}
        </tbody>
      </table>
    );
  }

}

export default OrdersList;
