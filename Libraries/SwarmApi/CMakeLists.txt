set(SRCS 
    src/SwarmApi.cpp
)
set(HDRS 
    inc/SwarmApi.h
)
set(TESTS 
    tests/test_swarm_api.cpp
)

project_template(SwarmApi LIBRARY
    HDRS ${HDRS}
    SRCS  ${SRCS}
    PUBLIC_INCLUDES ./inc
    TEST_SRCS ${TESTS}
    
)