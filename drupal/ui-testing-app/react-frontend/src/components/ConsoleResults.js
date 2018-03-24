import React from 'react';

class ConsoleResults extends React.Component {
  render() {
    return (
      <div className="col-12">
        <div className="form-group">
          <label className="mt-5" htmlFor="console-results">{this.props.title}</label>
          <textarea
            className="form-control"
            id="console-results"
            rows={this.props.textareaRows}
            value={this.props.consoleOutput.join('\n\n')}
            readOnly/>
        </div>
      </div>
    )
  }
}

export default ConsoleResults;