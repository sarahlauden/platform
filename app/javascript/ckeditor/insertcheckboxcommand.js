import Command from '@ckeditor/ckeditor5-core/src/command';

export default class InsertCheckboxCommand extends Command {
    execute( id ) {
    alert("omg its actually executing");
        this.editor.model.change( writer => {
            // Insert <checkboxDiv id="...">*</checkboxDiv> at the current selection position
            // in a way which will result in creating a valid model structure.
            this.editor.model.insertContent( createCheckbox( writer, id ) );
        } );
    }

    refresh() {
        const model = this.editor.model;
        const selection = model.document.selection;
        console.log(selection);
        console.log(selection.getFirstPosition());
        const allowedIn = model.schema.findAllowedParent( selection.getFirstPosition(), 'checkboxDiv' );

        this.isEnabled = allowedIn !== null;
        console.log('--------insertcheckboxcommand refresh');
        console.log(this.isEnabled);
    }
}

function createCheckbox( writer, id ) {
    const checkboxDiv = writer.createElement( 'checkboxDiv' );
    const checkboxInput = writer.createElement( 'checkboxInput' );
    const checkboxLabel = writer.createElement( 'checkboxLabel' );

    writer.append( checkboxInput, checkboxDiv );
    writer.append( checkboxLabel, checkboxDiv );

    // There must be at least one paragraph for the description to be editable.
    // See https://github.com/ckeditor/ckeditor5/issues/1464.
    //writer.appendElement( 'paragraph', answerText );

    return checkboxDiv;
}
