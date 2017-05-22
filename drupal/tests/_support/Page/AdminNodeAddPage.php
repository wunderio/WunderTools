<?php
/**
 * @file
 * Administration page for adding nodes.
 */

namespace Page;

class AdminNodeAddPage
{
    /**
     * @var string
     *   URL/path to this page.
     */
    protected static $URL = 'node/add';

    /**
     * @var string
     *   Submit button selector.
     */
    public static $submitSelector = "Save and publish";

    /**
     * @var string
     *   View node preview.
     */
    public static $editPreviewSelector = '#edit-preview';

    /**
     * Basic route example.
     *
     * @param string $type
     *   The content type to generate a path for.
     *
     * @return string
     *   Complete path to the page.
     */
    public static function route($type = '')
    {
        if ($type == '') {
            return static::$URL;
        } else {
            return static::$URL . '/' . $type;
        }
    }

}
