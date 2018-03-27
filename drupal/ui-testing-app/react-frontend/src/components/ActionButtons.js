import React from 'react';
import SubmitButton from './SubmitButton';
import ResetButton from './ResetButton';

class ActionButtons extends React.Component {
  render() {
    return (
      <div>
        <div className="btn-group mr-2" role="group">
          <SubmitButton
            disableSubmitButton={this.props.disableSubmitButton}
            label="Run selected tests"
            runSelectedTests={this.props.runSelectedTests}/>
        </div>
        <div className="btn-group" role="group">
          <ResetButton
            label="Reset"
            resetSelectedTests={this.props.resetSelectedTests}/>
        </div>
      </div>
    )
  }
}

export default ActionButtons;