import React from 'react';

class ResetButton extends React.Component {
  render() {
    return (
      <button
        type="button"
        className="btn btn-secondary"
        onClick={this.props.resetSelectedTests}>
        {this.props.label}
      </button>
    )
  }
}

export default ResetButton;