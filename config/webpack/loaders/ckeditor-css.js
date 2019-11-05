const { styles } = require( '@ckeditor/ckeditor5-dev-utils' );

module.exports = {
    test: /ckeditor5-[^/\\]+[/\\]theme[/\\].+\.css/,
    use: [
        {
            loader: 'style-loader',
            options: {
                injectType: 'singletonStyleTag'
            }
        },
        {
            loader: 'postcss-loader',
            options: styles.getPostCssConfig( {
                themeImporter: {
                    themePath: require.resolve( '@ckeditor/ckeditor5-theme-lark' )
                },
                minify: true
            } )
        },
    ]
}
