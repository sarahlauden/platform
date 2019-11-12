import React from 'react';

export default class ContentPreview extends React.Component {
    render() {
        const style = {
            '--content-part-image': `url(${ this.props.image })`
        };

        return <div
            className="content-part-preview"
            style={style}>
                <button
                    type="button"
                    className="content-part-preview__add"
                    onClick={() => this.props.onClick( this.props.id )}
                    title="Add to the editor"
                >
                    <span>+</span>
                </button>
                <span className="content-part-preview__name">{this.props.name}</span>
            </div>
    }
}
