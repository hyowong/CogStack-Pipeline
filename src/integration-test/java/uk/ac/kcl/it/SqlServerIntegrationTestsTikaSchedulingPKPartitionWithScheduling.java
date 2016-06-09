/* 
 * Copyright 2016 King's College London, Richard Jackson <richgjackson@gmail.com>.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package uk.ac.kcl.it;

import org.apache.log4j.Logger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import uk.ac.kcl.scheduling.ScheduledJobLauncher;
import uk.ac.uk.it.TestExecutionListeners.SqlServerTikaTestExecutionListener;

/**
 *
 * @author rich
 */
@RunWith(SpringJUnit4ClassRunner.class)
@TestPropertySource({
        "classpath:sql_server_test_config_tika.properties",
        "classpath:jms.properties",
        "classpath:deidentification.properties",
        "classpath:sql_server_db.properties",
        "classpath:tika.properties",
        "classpath:gate.properties",
        "classpath:elasticsearch.properties",
        "classpath:jobAndStep_partition_only_with_scheduling.properties"})
@ContextConfiguration(classes = {
        ScheduledJobLauncher.class,
        SqlServerTestUtils.class,
        TestUtils.class},
        loader = AnnotationConfigContextLoader.class)
@TestExecutionListeners(
        listeners = SqlServerTikaTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS)
public class SqlServerIntegrationTestsTikaSchedulingPKPartitionWithScheduling {

    final static Logger logger = Logger.getLogger(PostGresIntegrationTestsTikaPKPartitionWithScheduling.class);


    @Test
    @DirtiesContext
    public void sqlServerTikaPipelineTest() {
        try {
            Thread.sleep(300000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

}