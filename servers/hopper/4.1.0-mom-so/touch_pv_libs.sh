#!/bin/bash
find $PV_HOME -name '*.so*' -exec touch \{\} \;
echo "finished loading dso's"
