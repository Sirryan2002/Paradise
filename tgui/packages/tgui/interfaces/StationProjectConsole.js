import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, Section, Box, Tabs, Icon, TechGraph } from '../components';
import { Window } from '../layouts';

export const StationProjectConsole = () => {
  return (
    <Window resizable>
      <Window.Content>
        <div className="station-project-interface-container">
          <div className="station-project-sidenav">
            <Section title="Station Project Manager">
              <ProjectSideNav/>
            </Section>
          </div>
          <div className="station-project-content-container">
            <ProjectPageContent />
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

const ProjectCard = (props, context) => {
  const { act, data } = useBackend(context);
  const { projectName, projectShortDescription, projectDescription, projectImage, projectType } = props;

  return (
    <div className="projectcard">
      <h2>{projectName}</h2>
      <div style={{'max-width': '30em'}}>{projectShortDescription}</div>
      <img src={`data:image/jpeg;base64,${projectImage}`} style={{"margin": "2em"}}/>
      <div className='button-container'>
        <Button
          content="Project Details"
          color="blue"
          onClick={() => act('project_details')}
        />
        <Button
          content="Select Project"
          color="green"
          onClick={() => act('select_project', {
            project_type: projectType,
          })}
        />
      </div>
    </div>
  )
}

const ProjectSideNav = (props, context) => {
  const { data } = useBackend(context);
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  const {
    active_projects,
  } = data
  let projectIds = 1
  return (
    <Tabs vertical>
      <Tabs.Tab
        selected={0 === tabIndex}
        onClick={() => setTabIndex(0)}>
        <Icon name="shopping-bag" />
        <Box className="tab-name-container">Project Catalog</Box>
      </Tabs.Tab>
      {active_projects.map((project) => (
        <Tabs.Tab key={project.project_name}
          selected={projectIds++ === tabIndex}
          onClick={() => setTabIndex(1)}>
          <Icon name="project-diagram"/>
          <Box className="tab-name-container">{project.project_name}</Box>
        </Tabs.Tab>
      ))}
    </Tabs>
  );
}
const ProjectPageContent = (props, context) => {
  const [tabIndex] = useLocalState(context, 'tabIndex', 0);
  switch (tabIndex) {
    case 0:
      return <ProjectConsoleProjects />;
    case 1:
      return <ProjectTechGraph />;
    default:
      return "You are somehow on a tab that doesn't exist! Please let a coder know.";
  }
};
const ProjectTechGraph = (props, context) => {
  const { data } = useBackend(context);

  return (
    <TechGraph
      treeWidth={200}
      treeHeight={300}
    />
  );
};

const ProjectConsoleProjects = (props, context) => {
  const { data } = useBackend(context);

  const {
    station_projects
  } = data;

  return (
    <>
      {station_projects.map((project) => (
        <ProjectCard key={project.project_name}
          projectName={project.project_name}
          projectShortDescription={project.project_short_description}
          projectDescription={project.project_description}
          projectImage={project.project_image}
          projectType={project.project_type}
        />
      ))}
    </>
  );
};


