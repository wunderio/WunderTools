import React from 'react';

class TestItemCheckbox extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(event) {
    const updatedTest = {
      ...this.props.test,
      [event.currentTarget.name]: event.currentTarget.checked
    };
    this.props.updateState(event.currentTarget.value, updatedTest);
  }

  render() {
    return (
      <div className="form-check">
        <input
          type="checkbox"
          className="form-check-input"
          name="isChecked"
          id={this.props.test.id}
          ref="isChecked"
          value={this.props.test.id}
          onChange={this.handleChange}/>
        <label className="form-check-label" htmlFor={this.props.test.id}>
          {this.props.test.name}
        </label>
      </div>
    )
  }
}

export default TestItemCheckbox;