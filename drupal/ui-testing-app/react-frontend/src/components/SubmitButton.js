import React from "react";

class SubmitButton extends React.Component {
  render() {
    return (
      <button
        type="button"
        className="btn btn-primary"
        onClick={this.props.runSelectedTests}>
        {this.props.label}
      </button>
    )
  }
}

export default SubmitButton;