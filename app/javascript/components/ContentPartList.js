import React from 'react';
import ContentPartPreview from './ContentPartPreview';

export default class ContentPartList extends React.Component {
    render() {
        return <div className="demo__content-part-list">
            <h3>This is the sidebar!</h3>
            <ul>
                {this.props.contentParts.map( contentPart => {
                    return <li key={contentPart.id}>
                        <ContentPartPreview
                            id={contentPart.id}
                            onClick={this.props.onClick}
                            {...contentPart}
                        />
                    </li>;
                })}
            </ul>
            <p><b>Tip</b>: Clicking on a thing will add it to the editor.</p>
        </div>;
    }
}
